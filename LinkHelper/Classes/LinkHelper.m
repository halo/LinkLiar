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
  assert(listener == self.listener);
  assert(newConnection != nil);
  
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
  reply([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]);
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
