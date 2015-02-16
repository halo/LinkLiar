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

#import "LinkPreferences.h"

#import "LinkInterface.h"

const NSString *DebugFlag = @"debug";
const NSString *InterfaceForceFlag = @"force";
const NSString *InterfaceModifierFlag = @"modifier";
const NSString *InterfaceModifierRandom = @"random";
const NSString *InterfaceModifierDefine = @"define";
const NSString *InterfaceModifierOriginal = @"original";
const NSString *InterfaceModifierReset = @"reset";

@implementation LinkPreferences

// Continuously observed

+ (void) randomizeInterface:(LinkInterface*)interface force:(BOOL)force {
  [Log debug:@"Remembering to randomize hardware MAC %@ of %@", interface.hardMAC, interface.displayNameAndBSDName];
  [self setModifierValue:InterfaceModifierRandom forInterface:interface];
  if (force) [self setForceForInterface:interface];
}

+ (void) defineInterface:(LinkInterface*)interface withMAC:(NSString*)address force:(BOOL)force {
  [Log debug:@"Defining hardware MAC %@ of %@ to be %@", interface.hardMAC, interface.displayNameAndBSDName, address];
  [self setModifierValue:InterfaceModifierDefine forInterface:interface];
  if (force) [self setForceForInterface:interface];
}

+ (void) originalizeInterface:(LinkInterface*)interface force:(BOOL)force {
  [Log debug:@"Remembering to keep hardware MAC %@ of %@ in original state", interface.hardMAC, interface.displayNameAndBSDName];
  [self setModifierValue:InterfaceModifierOriginal forInterface:interface];
  if (force) [self setForceForInterface:interface];
}

// One-time triggers

+ (void) resetInterface:(LinkInterface*)interface {
  [Log debug:@"Remembering to reset MAC %@ of %@", interface.hardMAC, interface.displayNameAndBSDName];
  [self setObject:InterfaceModifierReset forKey:[self modifierKeyForInterface:interface]];
}

+ (void) forgetInterface:(LinkInterface*)interface {
  [Log debug:@"Forgetting MAC %@ of %@", interface.hardMAC, interface.displayNameAndBSDName];
  [self removeObjectForKey:[self modifierKeyForInterface:interface]];
}

+ (void) unforceInterface:(LinkInterface*)interface {
  [self removeObjectForKey:[self forceKeyForInterface:interface]];
}

// Preference querying

+ (NSUInteger) modifierOfInterface:(LinkInterface*)interface {
  NSString *modifier = [NSString stringWithFormat:@"%@", [self getObjectForKey:[self modifierKeyForInterface:interface]]];
  
  if ([InterfaceModifierRandom isEqualToString:modifier])   return ModifierRandom;
  if ([InterfaceModifierDefine isEqualToString:modifier])   return ModifierDefine;
  if ([InterfaceModifierOriginal isEqualToString:modifier]) return ModifierOriginal;
  if ([InterfaceModifierReset isEqualToString:modifier])    return ModifierReset;
  [Log debug:@"Don't know what to do with hardware MAC %@ of %@", interface.hardMAC, interface.displayNameAndBSDName];
  return ModifierUnknown;
}

+ (NSString*) definitionOfInterface:(LinkInterface*)interface {
  if ([self modifierOfInterface:interface] != ModifierDefine) return @"";
  NSString *key = [NSString stringWithFormat:@"%@.%@", interface.hardMAC, InterfaceModifierDefine];
  NSString *address = [self getObjectForKey:key];
  if (!address) return @"";
  return address;
}

+ (BOOL) forceOfInterface:(LinkInterface*)interface {
  return [InterfaceForceFlag isEqualToString:[self getObjectForKey:[self forceKeyForInterface:interface]]];
}

+ (BOOL) debugMode {
  return [self getObjectForKey:(NSString*)DebugFlag] != nil;
}

+ (void) toggleDebugMode {
  if (self.debugMode) {
    [Log debug:@"Deactivating Debug Mode..."];
    [self removeObjectForKey:(NSString*)DebugFlag];
  } else {
    [Log debug:@"Activating Debug Mode..."];
    [self setObject:DebugFlag forKey:(NSString*)DebugFlag];
  }
}

+ (NSString*) preferencesFilePath {
  NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
  NSString *folder = [path objectAtIndex:0];
  NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
  NSString *filename = [NSString stringWithFormat:@"%@.plist", bundleIdentifier];
  return [[folder stringByAppendingPathComponent:@"Preferences"] stringByAppendingPathComponent:filename];
}

// Internal

+ (void) setModifierValue:(const NSString*)value forInterface:(LinkInterface*)interface {
  [self setObject:value forKey:[self modifierKeyForInterface:interface]];
}

+ (NSString*) modifierKeyForInterface:(LinkInterface*)interface {
  return  [NSString stringWithFormat:@"%@.%@", interface.hardMAC, InterfaceModifierFlag];;
}

+ (NSString*) forceKeyForInterface:(LinkInterface*)interface {
  return  [NSString stringWithFormat:@"%@.%@", interface.hardMAC, InterfaceForceFlag];;
}

+ (void) setForceForInterface:(LinkInterface*)interface {
  [self setObject:InterfaceForceFlag forKey:[self forceKeyForInterface:interface]];
}

+ (void) setObject:object forKey:(NSString*)key {
  [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) removeObjectForKey:(NSString*)key {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
  [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) getObjectForKey:(NSString*)key {
  return [[NSUserDefaults standardUserDefaults] stringForKey:key];
}

@end
