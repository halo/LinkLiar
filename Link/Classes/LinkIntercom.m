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

- (void) ensureHelperTool {
  assert([NSThread isMainThread]);
  [self connectToHelperTool];
  
  [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
    DDLogDebug(@"Could not query Helper version, installing it...");
    if ([self elevateHelperTool]) {
      DDLogDebug(@"And moving on with execution...");
    } else {
      DDLogDebug(@"Giving up on Helper.");
    }
    
  }] getVersionWithReply:^(NSString *helperVersion) {
    NSString *myVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if ([helperVersion isEqualToString:myVersion]) {
      DDLogDebug(@"Helper is also at version %@", myVersion);
    } else {
      NSString *warning = [NSString stringWithFormat:@"I am at version %@ but the Helper is at %@. Please uninstall the helper manually (see https://github.com/halo/LinkLiar) and try again.", myVersion, helperVersion];
      NSLog(warning);
      //assert([NSThread isMainThread]);
      //NSAlert *alert = [NSAlert alertWithMessageText:@"Helpertool mismatch detected" defaultButton:@"Thanks" alternateButton:nil otherButton:nil informativeTextWithFormat:warning];
      //[alert runModal];
      [NSApp terminate:self];
    }
  }];

}

- (void) logText:(NSString*)text {
  DDLogDebug(@"%@", text);
}

- (void) logError:(NSError*)error {
  DDLogError(@"error details %@", error);
}

- (void) logWithFormat:(NSString*)format, ... {
  va_list ap;
  
  // any thread
  assert(format != nil);
  
  va_start(ap, format);
  [self logText:[[NSString alloc] initWithFormat:format arguments:ap]];
  va_end(ap);
}

// Ensures that we're connected to our helper tool.
- (void) connectToHelperTool {
  DDLogDebug(@"Connecting to Helper Tool...");

  //assert([NSThread isMainThread]);
  if (self.helperToolConnection) return;
  
  DDLogDebug(@"Establishing NSXPCConnection...");
  self.helperToolConnection = [[NSXPCConnection alloc] initWithMachServiceName:kLinkHelperIdentifier options:NSXPCConnectionPrivileged];
  self.helperToolConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LinkHelperProtocol)];
  DDLogDebug(@"NSXPCConnection instantiated");

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
      [self logText:@"connection interrupted\n"];
    }];
  };

  self.helperToolConnection.invalidationHandler = ^{
    // If the connection gets invalidated then, on the main thread, nil out our
    // reference to it.  This ensures that we attempt to rebuild it the next time around.
    self.helperToolConnection.invalidationHandler = nil;
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      self.helperToolConnection = nil;
      [self logText:@"connection invalidated\n"];
    }];
  };
  #pragma clang diagnostic pop
  DDLogDebug(@"Resuming connection...");
  [self.helperToolConnection resume];
  DDLogDebug(@"Connection resumed.");
  
}

- (void) connectAndExecuteCommandBlock:(void(^)(NSError *))commandBlock {
// Connects to the helper tool and then executes the supplied command block on the
// main thread, passing it an error indicating if the connection was successful.

  DDLogDebug(@"connectAndExecuteCommandBlock");
  //assert([NSThread isMainThread]);
  
  // Ensure that there's a helper tool connection in place.
  //if (self.helperToolConnection == nil)
  //[self elevateHelperTool];
  [self connectToHelperTool];
  
  // Run the command block.  Note that we never error in this case because, if there is
  // an error connecting to the helper tool, it will be delivered to the error handler
  // passed to -remoteObjectProxyWithErrorHandler:.  However, I maintain the possibility
  // of an error here to allow for future expansion.
  DDLogDebug(@"running command...");

  commandBlock(nil);
}

- (void) usingIdenticalHelperToolVersion:(void(^)(NSError*))block {
  [self connectToHelperTool];
  
  [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
    DDLogDebug(@"Could not query Helper version, installing it...");
    if ([self elevateHelperTool]) {
      DDLogDebug(@"And moving on with execution...");
      NSAlert *alert = [NSAlert alertWithMessageText:@"Helpertool installed" defaultButton:@"Got it." alternateButton:nil otherButton:nil informativeTextWithFormat:@"Now that you installed the helper tool for the first time you need to try again what you just did. From now on the changes will take effect immediately. Some day I'll figure out a more user-friendly way for this... It has to do with threads so it's complicated ;)"];
      [alert runModal];

      // I wish I could just to this. But it will not take effect in this sub-thread.
      // [self usingIdenticalHelperToolVersion:block];
    } else {
      DDLogDebug(@"Giving up on Helper.");
    }

  }] getVersionWithReply:^(NSString *helperVersion) {
    NSString *myVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if ([helperVersion isEqualToString:myVersion]) {
      DDLogDebug(@"Helper is also at version %@", myVersion);
      //[self connectAndExecuteCommandBlock:block];
      block(nil);
    } else {
      NSString *warning = [NSString stringWithFormat:@"I am at version %@ but the Helper is at %@. Please uninstall the helper manually (see https://github.com/halo/LinkLiar) and try again.", myVersion, helperVersion];
      DDLogDebug(warning);
      // FIXME Not good. Subthreads may crash NSAlert.
      NSAlert *alert = [NSAlert alertWithMessageText:@"Helpertool mismatch detected" defaultButton:@"Thanks" alternateButton:nil otherButton:nil informativeTextWithFormat:warning];
      [alert runModal];
    }
  }];
}

- (void) getVersion {
  DDLogDebug(@"getVersion");
  [self connectToHelperTool];

    [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
      [self logError:proxyError];
    }] getVersionWithReply:^(NSString *version) {
      [self logWithFormat:@"version = %@\n", version];
    }];
  //}
}

- (BOOL) elevateHelperTool {
  DDLogDebug(@"Elevating Helper Tool...");
  AuthorizationRef authRef = [self createAuthRef];
  
  if (authRef) {
    DDLogDebug(@"Got Authorization");
  } else {
    DDLogWarn(@"Authorization failed");
    return NO;
  }

  NSError *error = nil;
  if (![self blessHelperWithAuthRef:authRef error:&error]) {
    DDLogError(@"Failed to bless helper");
    DDLogError(@"%@", error);
    return NO;
  }
  DDLogDebug(@"Blessed the helper");
  return YES;
}

- (void) applyAddress:(NSString*)address toBSD:(NSString*)BSDName {
  DDLogDebug(@"applyAddress to BSD...");
  [self usingIdenticalHelperToolVersion:^(NSError * connectError) {
    if (connectError != nil) {
      DDLogDebug(@"applyAddress boom");
      [self logError:connectError];
    } else {
      [[self.helperToolConnection remoteObjectProxyWithErrorHandler:^(NSError * proxyError) {
        [self logError:proxyError];
      }] applyMACAddress:address toInterfaceWithBSD:BSDName withReply:^(BOOL success) {
        [self logWithFormat:@"reply = %li", success];
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
    NSLog(@"Failed to create AuthorizationRef, return code %i", status);
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
