#import "ClickableNSView.h"

@implementation ClickableNSView

- (void) mouseDown:(NSEvent*)event {
  [super mouseDown:event];
  switch ([event clickCount]) {
    case 1: [self wasSingleClicked]; break;
  }
}

- (void) wasSingleClicked {
  [self sendNotification:WasSingleClickedNotification];
}

- (void) sendNotification:(NSString*)notificationName {
  [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:self];
}

@end
