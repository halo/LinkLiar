#import "MACAddressFormatter.h"

@implementation MACAddressFormatter

- (BOOL) getObjectValue:(id*)obj forString:(NSString*)string errorDescription:(NSString**)error {
  *obj = string;
  return YES;
}

- (NSString*) stringForObjectValue:(id)object {
  if([object isKindOfClass:[NSString class]]) {
    return object;
  } else {
    return nil;
  }
}

- (BOOL) isPartialStringValid:(NSString*)partialString newEditingString:(NSString**)newString errorDescription:(NSString**)error {
  
  NSRange foundRange;
  NSCharacterSet *disallowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789:abcdefABCDEF"] invertedSet];
  foundRange = [partialString rangeOfCharacterFromSet:disallowedCharacters];
  if(foundRange.location != NSNotFound) {
    *error = @"MAC Adress contains invalid characters";
    NSBeep();
    return NO;
  }
  
  if([partialString length] > 17) {
    *error = @"MAC Adress is too long.";
    NSBeep();
    return(NO);
  }

  *newString = partialString; 
  return YES;
}

@end