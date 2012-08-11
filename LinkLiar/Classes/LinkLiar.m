#import "LinkLiar.h"

#import "Interface.h"
#import "MACAddresss.h"

@implementation LinkLiar
@synthesize helpPopover;

@synthesize wifi, wifiNameLabel, wifiSoftMAC, wifiSpinner;
@synthesize ethernet, ethernetNameLabel, ethernetSoftMAC, ethernetSpinner;
@synthesize wifiClickarea, ethernetClickarea, changePopover;
@synthesize editing, addressTextField, applyButton;

- (void) mainViewDidLoad {
  [self refreshGUI:self];
  [self setupObservers];
  [self randomizeMACInTextField:self];
}

- (void) refreshGUI:sender {
  wifi = [Interface wifi];
  ethernet = [Interface ethernet];
  [wifiNameLabel setStringValue:[wifi.displayName stringByAppendingFormat:@" %@", wifi.BSDName]];
  [wifiSoftMAC setStringValue:wifi.softMAC];
  [ethernetNameLabel setStringValue:[ethernet.displayName stringByAppendingFormat:@" %@", ethernet.BSDName]];
  [ethernetSoftMAC setStringValue:ethernet.softMAC];
}

- (void) setupObservers {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wasSingleClickedNotification:) name:WasSingleClickedNotification object:nil];
  [NSTimer scheduledTimerWithTimeInterval:(4) target:self  selector:@selector(refreshGUI:) userInfo:nil repeats:YES];
}

- (BOOL) control:(NSControl*)control textView:(NSTextView*)textView doCommandBySelector:(SEL)command {
  if (command == @selector(cancelOperation:)) {
    editing = @"none";
    [changePopover close];
  }
  return NO;
}

- (void) controlTextDidChange:(NSNotification*)notification {
  MACAddresss *address = [MACAddresss new];
  address.string = addressTextField.stringValue;
  if (address.isValid) {
    applyButton.enabled = true;
  } else {
    applyButton.enabled = false;
  }
}

- (void) wasSingleClickedNotification:(NSNotification*)notification {
  if ([notification object] == wifiClickarea) {
    if ([changePopover isShown] && [editing isEqualToString:@"wifi"]) {
      editing = @"none";
      [changePopover close];
    } else {
      editing = @"wifi";
     [self editWifi];
    }
  } else if ([notification object] == ethernetClickarea) {
    if ([changePopover isShown] && [editing isEqualToString:@"ethernet"]) {
      editing = @"none";
      [changePopover close];
    } else {
      editing = @"ethernet";
      [self editEthernet];
    }
  }
}

- (void) editWifi {
  [changePopover showRelativeToRect:[wifiSoftMAC bounds] ofView:wifiSoftMAC preferredEdge:NSMaxYEdge];
}

- (void) editEthernet {
  [changePopover showRelativeToRect:[ethernetSoftMAC bounds] ofView:ethernetSoftMAC preferredEdge:NSMaxYEdge];
}

- (IBAction) randomizeMACInTextField:sender {
  [addressTextField setStringValue:[MACAddresss random]];
}

- (IBAction) showHelp:sender {
 if ([helpPopover isShown]) {
   [helpPopover close];
  } else {
   [helpPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinXEdge];
 }
}

- (IBAction) applyAddress:sender {
  MACAddresss *address = [MACAddresss new];
  address.string = addressTextField.stringValue;
  if (address.isValid) {
    if ([editing isEqualToString:@"wifi"]) {
      [[self wifiSpinner] startAnimation:self];
      [self doApplyAddress:address onInterface:wifi];
      [[self wifiSpinner] stopAnimation:self];
    } else if ([editing isEqualToString:@"ethernet"]) {
      [[self ethernetSpinner] startAnimation:self];
      [self doApplyAddress:address onInterface:ethernet];
      [[self ethernetSpinner] stopAnimation:self];
    }
  }
}

- (void) doApplyAddress:(MACAddresss*)address onInterface:(Interface*)interface {
  [interface applyAddress:address];
  [changePopover close];
   addressTextField.stringValue = address.string;
  [self refreshGUI:self];
}

@end
