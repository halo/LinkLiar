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

@class LinkInterface;

typedef NS_ENUM(NSInteger, InterfaceModifiers) {
  ModifierRandom,
  ModifierDefine,
  ModifierOriginal,
  ModifierReset,
  ModifierUnknown
};

extern const NSString *InterfaceModifierFlag;

@interface LinkPreferences : NSObject

@property (readonly) NSUserDefaults *linkUserDefaults;
@property (readonly) NSString *bundleID;

// Public

+ (NSString*) preferencesFilePath;
+ (BOOL) debugMode;
+ (void) toggleDebugMode;

+ (BOOL) connectionWarningIgnored;
+ (void) ignoreConnectionWarning;

+ (void) randomizeInterface:(LinkInterface*)interface force:(BOOL)force;
+ (void) originalizeInterface:(LinkInterface*)interface force:(BOOL)force;
+ (void) defineInterface:(LinkInterface*)interface withMAC:(NSString*)address force:(BOOL)force;

+ (void) resetInterface:(LinkInterface*)interface;
+ (void) forgetInterface:(LinkInterface*)interface;

+ (BOOL) forceOfInterface:(LinkInterface*)interface;
+ (void) unforceInterface:(LinkInterface*)interface;

+ (NSString*) definitionOfInterface:(LinkInterface*)interface;
+ (NSUInteger) modifierOfInterface:(LinkInterface*)interface;

@end
