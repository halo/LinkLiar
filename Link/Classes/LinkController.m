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

#import "LinkController.h"

#import <SystemConfiguration/SystemConfiguration.h>

#import "LinkSynchronizer.h"
#import "LinkMACAddress.h"
#import "LinkMacAddressFormatter.h"
#import "LinkMenu.h"
#import "LinkHelper.h"
#import "LinkInterface.h"
#import "LinkInterfaces.h"
#import "LinkObserver.h"
#import "LinkPreferences.h"
#import "LinkInterfaces.h"
#import "LinkLogger.h"
#import "LinkIntercom.h"
#import "NSBundle+LoginItem.h"
#import "LinkCopyPastableNSTextField.h"

@implementation LinkController

@synthesize statusItem, statusMenu;
@synthesize linkSynchronizer, linkObserver;

- (void) awakeFromNib {
  [Log debug:@"Awoke from NIB"];
  self.statusMenu.delegate = self;
  self.statusItem.menu = self.statusMenu;
  [self startMonitoring];
  [self update];
}

- (void) update {
  [self refreshWithUpdate:YES];
}

- (void) refresh {
  [self refreshWithUpdate:NO];
}

- (void) updateAndRefresh {
  [self update];
  [self refreshSoon];
  [self refreshLater];
}

- (void) refreshFromTimer:sender {
  [self refresh];
}

- (void) refreshSoon {
  [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(refreshFromTimer:) userInfo:nil repeats:NO];
}

- (void) refreshLater {
  [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(refreshFromTimer:) userInfo:nil repeats:NO];
}

- (void) interfaceMACApplied:sender {
  [Log debug:@"A MAC address has been updated..."];
  [self refreshWithUpdate:NO];
}

- (void) refreshWithUpdate:(BOOL)performUpdate {
  [Log debug:@"Going to refresh..."];
  [self.statusMenu refreshAssumingHelperInstalled:NO];

  [self usingHelperTool:^(NSInteger helperStatus, NSString *helperVersion) {
    if (helperStatus == HelperReady) {
      if (performUpdate) [self applyInterfaces];
      [self.statusMenu refreshAssumingHelperInstalled:YES];
    } else {
      [self.statusMenu refreshAssumingHelperInstalled:NO];
    }
  }];

  // The rest is independent of the HelperTool
  self.statusItem.button.image = self.statusMenuIcon;
  self.statusItem.button.alternateImage = self.statusMenuIcon;
}

- (NSString*) requiredHelperVersion {
  return @"0.0.1";
}

- (void) startMonitoring {
  [Log debug:@"Observing Interface changes..."];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface" object:self.linkObserver];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface/en0/AirPort" object:self.linkObserver];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface/en1/AirPort" object:self.linkObserver];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface/en2/AirPort" object:self.linkObserver];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface/en3/AirPort" object:self.linkObserver];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfaceMACApplied:) name:LinkInterfaceMACAppliedNotification object:nil];
}

- (void) installHelperTool:(NSMenuItem*)sender {
  [self.linkSynchronizer installHelperTool];
}

- (void) applyInterfaces {
  [self.linkSynchronizer applyInterfaces];
}

- (void) interfacesDidChange:(NSNotification*)notififcation {
  [Log debug:@"Interface change detected..."];
  [self updateAndRefresh];
}

- (void) menuWillOpen:(NSMenu*)menu {
  [Log debug:@"Refreshing menu before opening it..."];
  [self refresh];
}

- (void) randomizeMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences randomizeInterface:interface force:YES];
  [self update];
  [self warnAboutLoosingConnection];
}

- (void) originalizeMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences originalizeInterface:interface force:YES];
  [self update];
}

- (void) specifyMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];

  NSString *title = [NSString stringWithFormat:@"Choose new MAC for %@", interface.displayName];
  NSString *description = [NSString stringWithFormat:@"The original hardware MAC for this Interface is %@", interface.hardMAC];
  NSString *newAddress = [self questionWithTitle:title andDescription:description andDefaultValue:@"aa:bb:cc:dd:ee:ff"];
  if (!newAddress) return;
  [Log debug:@"User specified %@", newAddress];
  
  [LinkPreferences defineInterface:interface withMAC:newAddress force:YES];
  [self update];
  [self warnAboutLoosingConnection];
}

- (void) resetMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences resetInterface:interface];
  [self update];
}

- (void) forgetMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences forgetInterface:interface];
}

- (void) toggleDebugMode:(NSMenuItem*)sender {
  [LinkPreferences toggleDebugMode];
}

- (void) toggleLogin:(NSMenuItem*)sender {
  if ([[NSBundle mainBundle] isLoginItem]) {
    [[NSBundle mainBundle] removeFromLoginItems];
  } else {
    [[NSBundle mainBundle] addToLoginItems];
  }
}

- (void) getHelp:(NSMenuItem*)sender {
  NSString *description = [NSString stringWithFormat:@"For now, I refer to https://github.com/halo/LinkLiar\n\nYou are currently running version %@ \n\nYour preferences are stored in %@\n\nHold the ⌥ key while the menu is open to see extra menu items.", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey], [LinkPreferences preferencesFilePath]];
  NSAlert *alert = [NSAlert alertWithMessageText:@"Help!" defaultButton:@"Thanks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", description];
  [alert runModal];
}

- (void) warnAboutLoosingConnection {
  if ([LinkPreferences connectionWarningIgnored]) return;
  NSString *description = [NSString stringWithFormat:@"Changing a MAC address may cause you to loose Internet connection on that Interface.\n\nIf that happens, just unplug the cable or turn off your Wi-Fi for a moment.\n\nThis warning will not appear again."];
  NSAlert *alert = [NSAlert alertWithMessageText:@"Just to let you know..." defaultButton:@"Okay, got it." alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@", description];
  [alert runModal];
  [LinkPreferences ignoreConnectionWarning];
}

- (NSString*) questionWithTitle:(NSString*)title andDescription:(NSString*)description andDefaultValue:(NSString*)defaultValue {
  NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@"%@", description];
  LinkCopyPastableNSTextField *input = [[LinkCopyPastableNSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];

  LinkMACAddressFormatter *formatter = [LinkMACAddressFormatter new];
  [input setFormatter:formatter];
  
  [input setStringValue:defaultValue];
  [alert setAccessoryView:input];
  NSInteger button = [alert runModal];
  if (button == NSAlertDefaultReturn) {
    [input validateEditing];
    return [input stringValue];
  } else {
    return nil;
  }
}

- (void) usingHelperTool:(void(^)(NSInteger, NSString*))block {
  [self.linkSynchronizer getVersionWithReply:^(NSString *helperVersion) {
    if (helperVersion == nil) {
      [Log debug:@"Helper Tool probably not installed!"];
      block(HelperMissing, nil);
    } else if ([helperVersion isEqualToString:self.requiredHelperVersion]) {
      [Log debug:@"Yeah, this is the Helper I want."];
      block(HelperReady, nil);
    } else {
      [Log debug:@"Helper Tool mismatch! I want %@ but Helper is at %@", self.requiredHelperVersion, helperVersion];
      block(HelperVersionMismatch, helperVersion);
    }
  }];
}

- (NSStatusItem*) statusItem {
  if (statusItem) return statusItem;
    
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
 
  self.statusItem.button.image = self.statusMenuIcon;
  self.statusItem.button.alternateImage = self.statusMenuIcon;
  self.statusItem.highlightMode = YES;
  
  statusItem.button.accessibilityTitle = @"LinkLiar";
  //statusItem.button.appearsDisabled = YES;
  return statusItem;
}

- (NSImage*) statusMenuIcon {
  NSImage *icon;
  if ([LinkInterfaces leaking]) {
    icon = [NSImage imageNamed:@"MenuIconLeaking"];
  } else {
    icon = [NSImage imageNamed:@"MenuIconProtected"];
  }
  [icon setTemplate:YES]; // Allows the correct highlighting of the icon when the menu is clicked.
  return icon;
}

- (LinkMenu*) statusMenu {
  if (statusMenu) return statusMenu;
  statusMenu = [LinkMenu new];
  return statusMenu;
}

- (LinkObserver*) linkObserver {
  if (linkObserver) return linkObserver;
  linkObserver = [LinkObserver new];
  return linkObserver;
}

- (LinkSynchronizer*) linkSynchronizer {
  if (linkSynchronizer) return linkSynchronizer;
  linkSynchronizer = [LinkSynchronizer new];
  return linkSynchronizer;
}

@end
