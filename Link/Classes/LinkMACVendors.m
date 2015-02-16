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

#import "LinkMACVendors.h"

@implementation LinkMACVendors

@synthesize all, byPrefix, byName;

+ (NSString*) randomPrefix {
  NSInteger vendorsCount = [[self sharedInstance].allPrefixes count];
  [Log debug:@"Choosing random MAC prefix among %li vendor prefixes...", (long)vendorsCount];
  NSUInteger randomIndex = arc4random() % vendorsCount;
  return ([self sharedInstance].allPrefixes)[randomIndex];
}

+ (NSString*) nameForMAC:(NSString*)address {
  NSArray *components = [address componentsSeparatedByString:@":"];
  NSRange range = NSMakeRange(0, 3);
  NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
  NSString *prefix = [[[components objectsAtIndexes:set] componentsJoinedByString:@":"] uppercaseString];
  NSString *name = ([self sharedInstance].byPrefix)[prefix];
  
  if (!name || [name isEqualToString:@"(null)"]) {
    return @"";
  } else {
    return name;
  }
}

+ (LinkMACVendors*) sharedInstance {
  static dispatch_once_t once;
  static LinkMACVendors *sharedInstance;
  dispatch_once(&once, ^{
    sharedInstance = [LinkMACVendors new];
  });
  return sharedInstance;
}

- (NSDictionary*) all {
  if (all) return all;
  NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mac_vendors" ofType:@"plist"];
  all = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
  return all;
}

- (NSDictionary*) byPrefix {
  return (self.all)[@"by_prefix"];
}

- (NSDictionary*) byName {
  return (self.all)[@"by_vendor"];
}

- (NSArray*) allPrefixes {
  return [self.byPrefix allKeys];
}

@end
