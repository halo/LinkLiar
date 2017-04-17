/*
 Copyright (c) 2015 funkensturm. https://github.com/halo/LinkLiar
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "LinkIntercom.h"

#import <ServiceManagement/ServiceManagement.h>
#import <Security/Authorization.h>
#import "LinkHelper.h"

@implementation LinkIntercom

- (BOOL) installHelperTool {
  NSAssert([NSThread isMainThread], @"You need to be on the main thread to install the Helper tool");
  return [self elevateHelperTool];
}

// Ensures that we're connected to our helper tool.
- (void) connectToHelperTool {
  [Log debug:@"Connecting to Helper Tool..."];

  //NSAssert([NSThread isMainThread], @"You need to be on the main thread to connect to the Helper tool");
  if (self.helperToolConnection) return;
  
  [Log debug:@"Establishing NSXPCConnection..."];
  self.helperToolConnection = [[NSXPCConnection alloc] initWithMachServiceName:kLinkHelperIdentifier options:NSXPCConnectionPrivileged];
  self.helperToolConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LinkHelperProtocol)];
  [Log debug:@"NSXPCConnection instantiated"];

  // We can ignore the retain cycle warning because a) the retain taken by the
  // invalidation handler block is released by us setting it to nil when the block
  // actually runs, and b) the retain taken by the block passed to -addOperationWithBlock:
  // will be released when that operation completes and the operation itself is deallocated
  // (notably self does not have a reference to the NSBlockOperation).
  #pragma clang diagnostic ignored "-Warc-retain-cycles"
  self.helperToolConnection.interruptionHandler = ^{
    // If the connection gets invalidated then, on the main thread, nil out our
    // reference to it.  This ensures that we attempt to rebuild it the next time around.
    self.helperToolConnection.invalidationHandler = nil;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      self.helperToolConnection = nil;
      [Log debug:@"XPC connection interrupted\n"];
    }];
  };

  self.helperToolConnection.invalidationHandler = ^{
    // If the connection gets invalidated then, on the main thread, nil out our
    // reference to it.  This ensures that we attempt to rebuild it the next time around.
    self.helperToolConnection.invalidationHandler = nil;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      self.helperToolConnection = nil;
      [Log debug:@"XPC connection invalidated\n"];
    }];
  };
  #pragma clang diagnostic pop
  [Log debug:@"Resuming connection..."];
  [self.helperToolConnection resume];
  [Log debug:@"Connection resumed."];
  
}

- (void) connectAndExecuteCommandBlock:(void(^)(NSError *))commandBlock {
  // Connects to the helper tool and then executes the supplied command block on the
  // main thread, passing it an error indicating if the connection was successful.

  [Log debug:@"connectAndExecuteCommandBlock"];
  
  [self connectToHelperTool];
  
  // Run the command block.  Note that we never error in this case because, if there is
  // an error connecting to the helper tool, it will be delivered to the error handler
  // passed to -remoteObjectProxyWithErrorHandler:.  However, I maintain the possibility
  // of an error here to allow for future expansion.
  [Log debug:@"running command..."];

  commandBlock(nil);
}

- (void) getVersionWithReply:(void(^)(NSString*))block {
  [Log debug:@"Intercom is going to check HelperTool version..."];

  [self connectAndExecuteCommandBlock:^(NSError *connectError) {
    if (connectError != nil) {
      [Log debug:@"Gee, Intercom didn't get a connection"];
      block(nil);
    }
    
    [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError *proxyError) {
    }] getVersionWithReply:^(NSString *helperVersion) {
      block(helperVersion);
    }];
  }];
}

- (BOOL) elevateHelperTool {
  [Log debug:@"Elevating Helper Tool..."];
  AuthorizationRef authRef = [self createAuthRef];
  
  if (authRef) {
    [Log debug:@"Got Authorization"];
  } else {
    [Log debug:@"Authorization failed"];
    return NO;
  }

  NSError *error = nil;
  if (![self blessHelperWithAuthRef:authRef error:&error]) {
    [Log debug:@"Failed to bless helper: %@", error.localizedDescription];
    return NO;
  }
  [Log debug:@"Blessed the helper"];
  return YES;
}

- (void) applyAddress:(NSString*)address toBSD:(NSString*)BSDName {
  [Log debug:@"applyAddress %@ to BSD %@", address, BSDName];
  [self connectAndExecuteCommandBlock:^(NSError *connectError) {
    if (connectError != nil) {
      [Log debug:@"connectError: %@", connectError.localizedDescription];
    } else {
      [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError *proxyError) {
        [Log debug:@"ProxyError: %@", proxyError.localizedDescription];
      }] applyMACAddress:address toInterfaceWithBSD:BSDName withReply:^(BOOL success) {
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:LinkInterfaceMACAppliedNotification object:nil];
        [Log debug:@"reply = %li", success];
      }];
    }
  }];
}

- (AuthorizationRef) createAuthRef {
  AuthorizationRef authRef = NULL;
  AuthorizationItem authItem = { kSMRightBlessPrivilegedHelper, 0, NULL, 0 };
  AuthorizationRights authRights = { 1, &authItem };
  AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed | kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;

  OSStatus status = AuthorizationCreate(&authRights, kAuthorizationEmptyEnvironment, flags, &authRef);
  if (status != errAuthorizationSuccess) {
    [Log debug:@"Failed to create AuthorizationRef, return code %i", status];
  }
  
  return authRef;
}

- (BOOL) blessHelperWithAuthRef:(AuthorizationRef)authRef error:(NSError**)error {
  CFErrorRef blessError;
  BOOL success = SMJobBless(kSMDomainSystemLaunchd, (__bridge CFStringRef)kLinkHelperIdentifier, authRef, &blessError);
  *error = (__bridge NSError*)blessError;
  return success;
}

@end
