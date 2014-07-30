@interface MACAddresss : NSObject

@property (strong) NSString *string;

+ (NSString*) random;
- (BOOL) isValid;

@end
