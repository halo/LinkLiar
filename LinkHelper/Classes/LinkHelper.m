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

#import "LinkHelper.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>

@interface LinkHelper () <NSXPCListenerDelegate, LinkHelperProtocol>

@property (atomic, strong, readwrite) NSXPCListener *listener;

@end

@implementation LinkHelper

- (id) init {
  self = [super init];
  if (self != nil) {
    self->_listener = [[NSXPCListener alloc] initWithMachServiceName:kLinkHelperIdentifier];
    self->_listener.delegate = self;
  }
  return self;
}

- (void) run {
  [self.listener resume];            // Tell the XPC listener to start processing requests.
  [[NSRunLoop currentRunLoop] run];  // Run the run loop to infinity and beyond.
}

- (BOOL) listener:(NSXPCListener*)listener shouldAcceptNewConnection:(NSXPCConnection*)newConnection {
  #pragma unused(listener)
  NSAssert(listener == self.listener, @"NSXPCListener is not my instance variable", listener, self.listener);
  NSAssert(newConnection != nil, @"XPC connection is nil", newConnection);
  
  newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(LinkHelperProtocol)];
  newConnection.exportedObject = self;
  [newConnection resume];
  return YES;
}

#pragma mark LinkHelperProtocol implementation

- (void) connectWithEndpointReply:(void (^)(NSXPCListenerEndpoint*))reply {
  reply([self.listener endpoint]);
}

- (void) getVersionWithReply:(void(^)(NSString *version))reply {
  reply([[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey]);
}

// It's painful to upgrade HelperTools so we keep this dead-simple.
- (void) applyMACAddress:(NSString*)address toInterfaceWithBSD:(NSString*)BSDName withReply:(void(^)(BOOL success))reply {
  NSTask *sudo = [NSTask new];
  
  [sudo setLaunchPath: @"/usr/bin/sudo"];
  [sudo setArguments: @[@"/sbin/ifconfig", BSDName, @"ether", address]];
  [sudo launch];

  reply(YES);
}

@end
