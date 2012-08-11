@interface MACAddresss : NSObject

@property (assign) NSString *string;

+ (NSString*) random;
- (BOOL) isValid;

@end
