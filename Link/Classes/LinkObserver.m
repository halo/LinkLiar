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

#import "LinkObserver.h"
#import "LinkLogger.h"

static void observerNotificationProxy(SCDynamicStoreRef store, CFArrayRef triggeredKeys, void* info) {
  NSString *key;
  NSEnumerator *keys = [(__bridge NSArray *)triggeredKeys objectEnumerator];
  NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
  
  while (key = [keys nextObject]) {
    //[Log debug:key];
    [notificationCenter postNotificationName:key object:(__bridge id)info userInfo:(__bridge NSDictionary*)SCDynamicStoreCopyValue(store, (__bridge CFStringRef) key)];
  }
}

@implementation LinkObserver

@synthesize dynamicStore, runLoop;

- (instancetype) init {
  self = [super init];
  if (self) {
    CFRunLoopAddSource([[NSRunLoop currentRunLoop] getCFRunLoop], self.runLoop, kCFRunLoopCommonModes);
    SCDynamicStoreSetNotificationKeys(self.dynamicStore, NULL, (__bridge CFArrayRef)@[@".*"]);
  }
  return self;
}

// Internal

- (SCDynamicStoreRef) dynamicStore {
  if (dynamicStore) return dynamicStore;
  SCDynamicStoreContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
  dynamicStore = SCDynamicStoreCreate(NULL, (__bridge CFStringRef) [[NSBundle mainBundle] bundleIdentifier], observerNotificationProxy, &context);
  return dynamicStore;
}

- (CFRunLoopSourceRef) runLoop {
  if (runLoop) return runLoop;
  runLoop = SCDynamicStoreCreateRunLoopSource(NULL, self.dynamicStore, 0);
  return runLoop;
}

@end
