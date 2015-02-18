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

#import "LinkInterface.h"

#import <CoreWLAN/CWInterface.h>

#import "LinkMACAddress.h"
#import "LinkMACVendors.h"

@implementation LinkInterface

@synthesize BSDName, displayName, hardMAC, softMAC, kind;

- (NSString*) displayNameAndBSDName {
  return [NSString stringWithFormat:@"%@ ∙ %@", self.displayName, self.BSDName];
}

- (BOOL) hasOriginalMAC {
  if ([self.hardMAC isEqualToString:self.softMAC]) {
    //[Log debug:@"%@ MAC %@ is original", self.displayNameAndBSDName, self.hardMAC);
    return YES;
  } else {
    //[Log debug:@"%@ MAC %@ is NOT the original %@", self.displayNameAndBSDName, self.hardMAC, self.softMAC);
    return NO;
  }
}

// We cannot work with in-built Wi-Fi (aka Airport) when it is powered off.
// This is a very efficient way to determine the power state of the Wi-Fi.
//
- (BOOL) isPoweredOffWifi {
  CWInterface *interface = [CWInterface interfaceWithName:self.BSDName];
  if (!interface) return NO;
  return (!interface.powerOn);
}

// Caching the ifconfig result to avoid running it too often.
//
- (NSString*) softMAC {
  if (softMAC) return softMAC;
  softMAC = [self softMACLive];
  return softMAC;
}

// This method runs "ifconfig" without superuser privileges to determine
// the currently assigned MAC address. It returns it as NSString.
//
- (NSString*) softMACLive {
  if (!self.kind) return @"";
  
  // Getting the Task bootstrapped
  NSTask *ifconfig = [NSTask new];
  NSPipe *pipe = [NSPipe pipe];
  NSFileHandle *file = [pipe fileHandleForReading];
  
  // Configuring the ifconfig command
  [ifconfig setLaunchPath: @"/sbin/ifconfig"];
  [ifconfig setArguments: @[self.BSDName]];
  [ifconfig setStandardOutput: pipe];
  // Starting the Task
  [ifconfig launch];
  
  // Reading the result from stdout
  NSData *data = [file readDataToEndOfFile];
  NSString *cmdResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  
  if (![cmdResult containsString:@"ether"]) return NULL;
  
  // Searching for the MAC address in the result
  NSString *currentMAC = [[[cmdResult componentsSeparatedByString:@"ether "] lastObject] componentsSeparatedByString:@" "][0];
  return currentMAC;
}

- (NSString*) softVendorName {
  return [LinkMACVendors nameForMAC:self.softMAC];
}

- (NSInteger) BSDNumber {
  return [[self.BSDName stringByReplacingOccurrencesOfString:@"en" withString:@""] intValue];
}

@end
