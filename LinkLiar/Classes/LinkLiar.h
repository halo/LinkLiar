#import <PreferencePanes/PreferencePanes.h>

#import "Interface.h"

@interface LinkLiar : NSPreferencePane

@property (assign) Interface *wifi;
@property (assign) Interface *ethernet;
@property (assign) NSString *editing;

@property (strong) IBOutlet NSTextField *wifiNameLabel;
@property (strong) IBOutlet NSTextField *wifiSoftMAC;
@property (strong) IBOutlet NSTextField *ethernetNameLabel;
@property (strong) IBOutlet NSTextField *ethernetSoftMAC;
@property (strong) IBOutlet NSProgressIndicator *wifiSpinner;
@property (strong) IBOutlet NSProgressIndicator *ethernetSpinner;
@property (strong) IBOutlet NSPopover *helpPopover;

@property (strong) IBOutlet NSView *wifiClickarea;
@property (strong) IBOutlet NSView *ethernetClickarea;
@property (strong) IBOutlet NSPopover *changePopover;
@property (strong) IBOutlet NSTextField *addressTextField;
@property (strong) IBOutlet NSButton *applyButton;

- (IBAction) applyAddress:sender;
- (IBAction) randomizeMACInTextField:sender;
- (IBAction) showHelp:sender;

@end
