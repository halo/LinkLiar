#import "MACAddresss.h"

@implementation MACAddresss

@synthesize string;

/* Some MAC address roulette.
 * Returns a random, full MAC address, separated by colons.
 */
+ (NSString*) random {
  // We will perform this with an Array that holds the HEX values
  NSMutableArray *components = [[[NSMutableArray alloc] init] autorelease];
  // Six times we will add something to the Array
  for (NSInteger i = 0; i < 6; i++) {
    // Each time we add two random HEX values combined in one NSString. E.g. "AF" or "5C"
    NSString *component = [[[NSString alloc] initWithFormat:@"%1X%1X", arc4random() % 15, arc4random() % 15] autorelease];
    // Please in lower case
    [components addObject:[component lowercaseString]];
  }
  // Put it all together by joining the six components with colons
  return [components componentsJoinedByString:@":"];
}

/* This method takes some junk string as input and tries to format it as MAC address
 * separated by colons. Note that it won't check for valid characters, it will only
 * deal with the colons. The character validity is guaranteed via the MACAddressFormatter.
 */
- (MACAddresss*) sanitize {
  // Stripping all existing colons
  string = [[self string] stringByReplacingOccurrencesOfString:@":" withString:@""];
  // Adding fresh colons
  NSMutableString* formatted = [[string mutableCopy] autorelease];
  if ([formatted length] > 10) [formatted insertString:@":" atIndex:10];
  if ([formatted length] > 8) [formatted insertString:@":" atIndex:8];
  if ([formatted length] > 6) [formatted insertString:@":" atIndex:6];
  if ([formatted length] > 4) [formatted insertString:@":" atIndex:4];
  if ([formatted length] > 2) [formatted insertString:@":" atIndex:2];
  self.string = formatted;
  return self;
}

- (BOOL) isValid {
  [self sanitize];
  return [string length] == 17;
}

@end
