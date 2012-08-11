@class MACAddresss;

@interface Interface : NSObject {

  NSString *BSDName;
  NSString *displayName;
  NSString *hardMAC;
  NSString *kind;
  
}

// Attributes
@property (nonatomic, assign) NSString *BSDName;
@property (nonatomic, assign) NSString *displayName;
@property (nonatomic, assign) NSString *hardMAC;
@property (nonatomic, assign) NSString *kind;

// Class Methods
+ (Interface*) ethernet;
+ (Interface*) wifi;

// Instance Methods
- (NSString*) softMAC;
- (void) applyAddress:(MACAddresss*)address;

@end
