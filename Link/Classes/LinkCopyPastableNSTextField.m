//
//  CopyPastableNSTextField.m
//  Link
//
//  Created by orange on 2017-04-17.
//  Copyright © 2017 xdissent.com. All rights reserved.
//

#import "LinkCopyPastableNSTextField.h"

@implementation LinkCopyPastableNSTextField

- (BOOL)performKeyEquivalent:(NSEvent *)theEvent {
  [Log debug:@"11111111"];
  if (([theEvent type] == NSKeyDown) && ([theEvent modifierFlags] & NSCommandKeyMask)) {
    [Log debug:@"22222"];
    NSResponder * responder = [[self window] firstResponder];

    if ((responder != nil) && [responder isKindOfClass:[NSTextView class]]) {
      [Log debug:@"3333"];
      NSTextView * textView = (NSTextView *)responder;
      NSRange range = [textView selectedRange];
      bool bHasSelectedTexts = (range.length > 0);

      unsigned short keyCode = [theEvent keyCode];

      bool bHandled = false;

      if (keyCode == 6) { // Z
        if ([[textView undoManager] canUndo]) {
          [[textView undoManager] undo];
          bHandled = true;
        }
      } else if (keyCode == 7 && bHasSelectedTexts) {  // X
        [textView cut:self];
        bHandled = true;
      } else if (keyCode== 8 && bHasSelectedTexts) {  // C
        [textView copy:self];
        bHandled = true;
      } else if (keyCode == 9) {  // V
        [textView paste:self];
        bHandled = true;
      } else if (keyCode == 0) {  // A
        [textView selectAll:self];
        bHandled = true;
      }

      if (bHandled)
        return YES;
    }
  }

  return NO;
}

@end
