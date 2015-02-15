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

#import "LinkSynchronizer.h"

#import "LinkIntercom.h"
#import "LinkInterface.h"
#import "LinkInterfaces.h"
#import "LinkMACAddress.h"
#import "LinkPreferences.h"

@implementation LinkSynchronizer

@synthesize linkIntercom;

- (void) ensureHelperTool {
  [self.linkIntercom ensureHelperTool];
}

- (void) applyInterfaces {
  NSString *newAddress;
  
  for (LinkInterface* interface in [LinkInterfaces all]) {
    switch ([LinkPreferences modifierOfInterface:interface]) {
        
      case ModifierRandom:
        newAddress = [LinkMACAddress random];
        DDLogDebug(@"Randomizing hardware MAC %@ of %@ to MAC %@", interface.hardMAC, interface.displayNameAndBSDName, newAddress);
        [self.linkIntercom applyAddress:newAddress toBSD:interface.BSDName];
        break;
        
      case ModifierDefine:
        newAddress = [LinkPreferences definitionOfInterface:interface];
        DDLogDebug(@"Defining hardware MAC %@ of %@ to MAC %@", interface.hardMAC, interface.displayNameAndBSDName, newAddress);
        [self.linkIntercom applyAddress:newAddress toBSD:interface.BSDName];
        break;
        
      case ModifierOriginal:
        newAddress = interface.hardMAC;
        DDLogDebug(@"Setting hardware MAC %@ of %@ to original MAC %@", interface.hardMAC, interface.displayNameAndBSDName, newAddress);
        [self.linkIntercom applyAddress:interface.hardMAC toBSD:interface.BSDName];
        break;

      case ModifierReset:
        newAddress = interface.hardMAC;
        DDLogDebug(@"Resetting hardware MAC %@ of %@ to original MAC %@ and then forgetting about it", interface.hardMAC, interface.displayNameAndBSDName, newAddress);
        [self.linkIntercom applyAddress:newAddress toBSD:interface.BSDName];
        [LinkPreferences forgetInterface:interface];
        break;

      default:
        continue;
        break;
    }
  }
}

- (LinkIntercom*) linkIntercom {
  if (linkIntercom) return linkIntercom;
  linkIntercom = [LinkIntercom new];
  return linkIntercom;
}

@end
