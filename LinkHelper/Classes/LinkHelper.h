#define kLinkHelperIdentifier @"com.funkensturm.LinkHelper"

@protocol LinkHelperProtocol

@required

- (void) connectWithEndpointReply:(void(^)(NSXPCListenerEndpoint *endpoint))reply;

- (void) getVersionWithReply:(void(^)(NSString *version)) reply;
- (void) applyMACAddress:(NSString*)address toInterfaceWithBSD:(NSString*)BSDName withReply:(void(^)(BOOL success))reply;

@end

@interface LinkHelper : NSObject

- (instancetype) init;
- (void) run;

@end
