#import "LinkHelper.h"

int main(int argc, char **argv) {

  @autoreleasepool {
    LinkHelper *linkHelper = [LinkHelper new];
    [linkHelper run];
  }
  
  // We should never get here
  return EXIT_FAILURE;
}
