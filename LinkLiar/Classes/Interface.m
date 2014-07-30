#import "Interface.h"

#import "MACAddresss.h"
#import <SystemConfiguration/SystemConfiguration.h>

@implementation Interface

@synthesize BSDName, displayName, hardMAC, kind;

/* Returns info about all available Interfaces.
 */
+ (NSArray*) all {
  NSMutableArray *result = [NSMutableArray new];
    @autoreleasepool {

    NSArray *interfaces_ = (NSArray*) CFBridgingRelease(SCNetworkInterfaceCopyAll());
     for (id interface_ in interfaces_) {
      Interface* interface = [self new];
      SCNetworkInterfaceRef interfaceRef = (__bridge SCNetworkInterfaceRef)interface_;
      interface.BSDName = (__bridge NSString*)SCNetworkInterfaceGetBSDName(interfaceRef);
      interface.displayName = (__bridge NSString*)SCNetworkInterfaceGetLocalizedDisplayName(interfaceRef);
      interface.hardMAC = (__bridge NSString*)SCNetworkInterfaceGetHardwareAddressString(interfaceRef);
      interface.kind = (__bridge NSString*)SCNetworkInterfaceGetInterfaceType(interfaceRef);
      [result addObject:interface];
    }

    return (NSArray*)result;
  }
}

+ (Interface*) ethernet {
  NSArray *interfaces = [self all];
  for (Interface *interface in interfaces) {
    BOOL isNotBluetooth = [[interface.displayName stringByReplacingOccurrencesOfString:@"tooth" withString:@""] isEqualToString:interface.displayName];
    if ([interface.kind isEqualToString:@"Ethernet"] && isNotBluetooth && ([interface.BSDName isEqualToString:@"en0"] || [interface.BSDName isEqualToString:@"en1"] || [interface.BSDName isEqualToString:@"en2"] || [interface.BSDName isEqualToString:@"en3"])) {
      //DLog(@"Identified Ethernet Interface: <%@> <%@> <%@>", interface.BSDName, interface.kind, interface.displayName);
      return interface;
    }
    
  }
  //DLog(@"Hey! You don't have a Ethernet Interface. Weird.");
  return [self new];
}

+ (Interface*) wifi {
  NSArray *interfaces = [self all];

  for (Interface *interface in interfaces) {
    if ([interface.kind isEqualToString:@"IEEE80211"]) {
      //DLog(@"Identified Wi-Fi Interface: %@", interface.BSDName);
      return interface;
    }
  }
  //DLog(@"Hey! You don't have a Wi-Fi Interface. Weird.");
  
  return [self new];
}

/* This method runs "ifconfig" without superuser privileges to determine 
 * the currently assigned MAC address. It returns it as NSString.
 */
- (NSString*) softMAC {
  if (!self.kind) return @"";
  // Getting the Task bootstrapped
  NSTask *ifconfig = [[NSTask alloc] init];
  NSPipe *pipe = [NSPipe pipe];
  NSFileHandle *file = [pipe fileHandleForReading];
  
  // Configuring the ifconfig command
  [ifconfig setLaunchPath: @"/sbin/ifconfig"];
  [ifconfig setArguments: [NSArray arrayWithObjects: self.BSDName, nil]];
  [ifconfig setStandardOutput: pipe];
  // Starting the Task
  [ifconfig launch];
  
  // Reading the result from stdout
  NSData *data = [file readDataToEndOfFile];
  NSString *cmdResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  // Searching for the MAC address in the result
  NSString *currentMAC = [[[[cmdResult componentsSeparatedByString:@"ether "] lastObject] componentsSeparatedByString:@" "] objectAtIndex:0]; 
  return currentMAC;
}

- (void) applyAddress:(MACAddresss*)address {
  if (!self.kind) return;
  NSDictionary *error = [NSDictionary new];
  NSString *command = [self changeCommandForInterface:self.BSDName usingAddress:address.string];
  NSString *script = [[NSString new] stringByAppendingFormat:@"do shell script \"%@\" with administrator privileges", command];
  NSAppleScript *appleScript = [[NSAppleScript new] initWithSource:script];
  [appleScript executeAndReturnError:&error];
}

- (NSString*) changeCommandForInterface:(NSString*)interfaceBSDName usingAddress:(NSString*)address {
  return [[NSString new] stringByAppendingFormat:@"ifconfig %@ ether %@", interfaceBSDName, address];
}

@end
