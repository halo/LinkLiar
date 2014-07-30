@class MACAddresss;

@interface Interface : NSObject {}

// Attributes
@property (nonatomic, strong) NSString *BSDName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *hardMAC;
@property (nonatomic, strong) NSString *kind;

// Class Methods
+ (Interface*) ethernet;
+ (Interface*) wifi;

// Instance Methods
- (NSString*) softMAC;
- (void) applyAddress:(MACAddresss*)address;

@end
