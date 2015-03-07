//
//  NSBundle+LoginItem.m
//  IYLoginItem
//
//  Created by Ian Ynda-Hummel on 6/8/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import "NSBundle+LoginItem.h"

#import <CoreServices/CoreServices.h>

@interface NSBundle (LoginItemPrivate)
- (LSSharedFileListItemRef)itemRefWithListRef:(LSSharedFileListRef)listRef;
@end

@implementation NSBundle (LoginItem)

- (BOOL)isLoginItem {
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (!loginItems) return NO;

    LSSharedFileListItemRef loginItemRef = [self itemRefWithListRef:loginItems];
    if (!loginItemRef) return NO;

    return YES;
}

- (void)addToLoginItems {
    NSURL *bundleURL = self.bundleURL;

    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (!loginItems) return;

    LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                 kLSSharedFileListItemLast,
                                                                 NULL,
                                                                 NULL,
                                                                 (__bridge CFURLRef)bundleURL,
                                                                 NULL,
                                                                 NULL);

    if (item) CFRelease(item);

    CFRelease(loginItems);
}

- (void)removeFromLoginItems {
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    if (!loginItems) return;

    LSSharedFileListItemRef loginItemRef = [self itemRefWithListRef:loginItems];
    if (!loginItemRef) return;

    LSSharedFileListItemRemove(loginItems, loginItemRef);
}

- (LSSharedFileListItemRef)itemRefWithListRef:(LSSharedFileListRef)listRef {
    NSArray *listItems = (__bridge NSArray *)LSSharedFileListCopySnapshot(listRef, NULL);

    for (NSInteger i = 0; i < listItems.count; ++i) {
        LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)listItems[i];
        CFURLRef urlRef;
        OSStatus error = LSSharedFileListItemResolve(itemRef, 0, &urlRef, NULL);

        if (error != noErr) continue;

        if (CFEqual(urlRef, (__bridge CFURLRef)self.bundleURL)) return itemRef;
    }

    return NULL;
}

@end
