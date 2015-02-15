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
#import "LinkMACAddressFormatter.h"
#import "LinkMenu.h"
#import "LinkHelper.h"
#import "LinkInterface.h"
#import "LinkInterfaces.h"
#import "LinkObserver.h"
#import "LinkPreferences.h"
#import "LinkInterfaces.h"

@implementation LinkController

@synthesize statusItem, statusMenu;
@synthesize linkSynchronizer, linkObserver;

- (void) awakeFromNib {
  DDLogDebug(@"Awoke from NIB");
  self.statusMenu.delegate = self;
  self.statusItem.menu = self.statusMenu;
  [self ensureHelperTool];
  [self startMonitoring];
  [self update];
}

- (void) startMonitoring {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(interfacesDidChange:) name:@"State:/Network/Interface" object:self.linkObserver];
}

- (void) ensureHelperTool {
  [self.linkSynchronizer ensureHelperTool];
}

- (void) update {
  [self.linkSynchronizer applyInterfaces];
  [self.statusMenu refresh];
  self.statusItem.button.image = self.statusMenuIcon;
  self.statusItem.button.alternateImage = self.statusMenuIcon;
}

- (void) interfacesDidChange:(NSNotification*)notififcation {
  DDLogDebug(@"Interface change detected...");
  [self update];
}

- (void) menuWillOpen:(NSMenu*)menu {
  DDLogDebug(@"Refreshing menu before opening it...");
  [self.statusMenu refresh];
}

- (void) randomizeMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences randomizeInterface:interface];
  [self update];
}

- (void) originalizeMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];
  [LinkPreferences originalizeInterface:interface];
  [self update];
}

- (void) specifyMAC:(NSMenuItem*)sender {
  LinkInterface *interface = [LinkInterfaces interfaceByBSDNumber:sender.tag];

  NSString *title = [NSString stringWithFormat:@"Choose new MAC for %@", interface.displayName];
  NSString *description = [NSString stringWithFormat:@"The original hardware MAC for this Interface is %@", interface.hardMAC];
  NSString *newAddress = [self questionWithTitle:title andDescription:description andDefaultValue:@"aa:bb:cc:dd:ee:ff"];
  if (!newAddress) return;
  DDLogDebug(@"User specified %@", newAddress);
  
  [LinkPreferences defineInterface:interface withMAC:newAddress];
  [self update];
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

- (void) getHelp:(NSMenuItem*)sender {
  NSAlert *alert = [NSAlert alertWithMessageText:@"Help!" defaultButton:@"Thanks" alternateButton:nil otherButton:nil informativeTextWithFormat:@"I need somebody."];
  [alert runModal];
}

- (NSString*) questionWithTitle:(NSString*)title andDescription:(NSString*)description andDefaultValue:(NSString*)defaultValue {
  NSAlert *alert = [NSAlert alertWithMessageText:title defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:description];
  NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];

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

- (NSStatusItem*) statusItem {
  if (statusItem) return statusItem;
    
  statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
 
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
