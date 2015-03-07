//
//  NSBundle+LoginItem.h
//  IYLoginItem
//
//  Created by Ian Ynda-Hummel on 6/8/13.
//  Copyright (c) 2013 Ian Ynda-Hummel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (LoginItem)

// Returns YES if the bundle is a login item such that it will be launched
// every time the currently logged in user logs in.
- (BOOL)isLoginItem;

// Takes the bundle and adds it as a login item such that it will be launched
// every time the currently logged in user logs in. If the bundle is already a
// login item this method has no additional effect.
- (void)addToLoginItems;

// Takes the bundle and removes it from login items such that it will not be
// launched every time the currently logged in user logs in. If the bundle is
// not a login item this method has no additional effect.
- (void)removeFromLoginItems;

@end
