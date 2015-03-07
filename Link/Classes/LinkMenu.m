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

#import "LinkMenu.h"

#import "LinkController.h"
#import "LinkInterfaces.h"
#import "LinkInterface.h"
#import "LinkPreferences.h"
#import "NSBundle+LoginItem.h"

@implementation LinkMenu

@synthesize refreshItem, helpItem, debugItem, quitItem;

- (void) refreshAssumingHelperInstalled:(BOOL)helperInstalled {
  
  [self removeAllItems];
  
  if (!helperInstalled) [self addHelperItem];
  [self addInterfaceItemsActionable:helperInstalled];

  [self addItem:self.helpItem];
  [self addItem:self.emptyItem];
  [self addItem:self.debugItem];
  [self addItem:self.emptyItem];
  [self addItem:self.startupItem];
  [self addItem:self.quitItem];
}

- (void) addHelperItem {
  NSMenuItem *installHelperItem = [[NSMenuItem alloc] initWithTitle:@"Authorize LinkLiar..." action:@selector(installHelperTool:) keyEquivalent:@""];
  installHelperItem.target = self.delegate;
  [self addItem:installHelperItem];
  [self addItem:[NSMenuItem separatorItem]];
}

- (void) addInterfaceItemsActionable:(BOOL)actionable {
  for (LinkInterface* interface in [LinkInterfaces all]) {
    [self addItem:[self menuForInterface:interface actionable:actionable]];
    [self addItem:[NSMenuItem separatorItem]];
  }
}

- (NSMenuItem*) menuForInterface:(LinkInterface*)interface actionable:(BOOL)actionable {
  [self addItem:[[NSMenuItem alloc] initWithTitle:interface.displayNameAndBSDName action:NULL keyEquivalent:@""]];
  
  NSMenuItem *mainItem = [NSMenuItem new];
  mainItem.title = interface.softMAC;
  mainItem.state = [interface hasOriginalMAC];
  mainItem.onStateImage = [NSImage imageNamed:@"InterfaceLeaking"];
  if (actionable) mainItem.submenu = [self submenuForInterface:interface];
  return mainItem;
}

- (NSMenu*) submenuForInterface:(LinkInterface*)interface {
  NSMenu *submenu = [NSMenu new];
  
  if (![interface.softVendorName isEqualToString:@""]) {
    NSMenuItem *vendorNameItem = [[NSMenuItem alloc] initWithTitle:interface.softVendorName action:NULL keyEquivalent:@""];
    [submenu addItem:vendorNameItem];
    [submenu addItem:[NSMenuItem separatorItem]];
  }
  
  if (interface.isPoweredOffWifi) {
    NSMenuItem *poweredOffItem = [[NSMenuItem alloc] initWithTitle:@"Powered off" action:NULL keyEquivalent:@""];
    [submenu addItem:poweredOffItem];
  } else {

    NSMenuItem *forgetItem = [[NSMenuItem alloc] initWithTitle:@"Do nothing" action:@selector(forgetMAC:) keyEquivalent:@""];
    forgetItem.tag = interface.BSDNumber;
    forgetItem.target = self.delegate;
    forgetItem.state = [LinkPreferences modifierOfInterface:interface] == ModifierUnknown;
    [submenu addItem:forgetItem];
    
    NSMenuItem *randomizeItem = [[NSMenuItem alloc] initWithTitle:@"Random" action:@selector(randomizeMAC:) keyEquivalent:@""];
    randomizeItem.tag = interface.BSDNumber;
    randomizeItem.target = self.delegate;
    randomizeItem.state = [LinkPreferences modifierOfInterface:interface] == ModifierRandom;
    [submenu addItem:randomizeItem];

    NSMenuItem *specifyItem = [[NSMenuItem alloc] initWithTitle:@"Define manually" action:@selector(specifyMAC:) keyEquivalent:@""];
    specifyItem.tag = interface.BSDNumber;
    specifyItem.target = self.delegate;
    specifyItem.state = [LinkPreferences modifierOfInterface:interface] == ModifierDefine;
    [submenu addItem:specifyItem];
    
    NSMenuItem *originalizeItem = [[NSMenuItem alloc] initWithTitle:@"Keep original" action:@selector(originalizeMAC:) keyEquivalent:@""];
    originalizeItem.tag = interface.BSDNumber;
    originalizeItem.target = self.delegate;
    originalizeItem.state = [LinkPreferences modifierOfInterface:interface] == ModifierOriginal;
    [submenu addItem:originalizeItem];
    
    if (![interface hasOriginalMAC]) {
      NSMenuItem *resetItem = [[NSMenuItem alloc] initWithTitle:@"Reset to original" action:@selector(resetMAC:) keyEquivalent:@""];
      resetItem.tag = interface.BSDNumber;
      resetItem.target = self.delegate;
      [submenu addItem:[NSMenuItem separatorItem]];
      [submenu addItem:resetItem];
      
      NSMenuItem *originalMAC = [[NSMenuItem alloc] initWithTitle:interface.hardMAC action:NULL keyEquivalent:@""];
      [submenu addItem:originalMAC];
    }
  }
  return submenu;
}

- (NSMenuItem*) helpItem {
  NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Help" action:@selector(getHelp:) keyEquivalent:@""];
  item.target = self.delegate;
  return item;
}

- (NSMenuItem*) startupItem {
  NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Launch at startup" action:@selector(toggleLogin:) keyEquivalent:@""];
  item.state = [[NSBundle mainBundle] isLoginItem];
  item.keyEquivalentModifierMask = NSAlternateKeyMask;
  item.alternate = YES;
  item.target = self.delegate;
  return item;
}

- (NSMenuItem*) emptyItem {
  NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Help" action:@selector(getHelp:) keyEquivalent:@""];
  [item setView:[[NSView alloc] initWithFrame:NSMakeRect(0, 0, 0, 0)]];
  item.target = self.delegate;
  return item;
}

- (NSMenuItem*) debugItem {
  NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Debug Mode" action:@selector(toggleDebugMode:) keyEquivalent:@""];
  item.target = self.delegate;
  item.keyEquivalentModifierMask = NSAlternateKeyMask;
  item.state = [LinkPreferences debugMode];
  item.alternate = YES;
  return item;
}

- (NSMenuItem*) quitItem {
  NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
  return item;
}

@end
