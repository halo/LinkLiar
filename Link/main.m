#import "LinkLogger.h"

int main(int argc, char *argv[]) {
  
  #ifdef DEBUG
    [LinkLogger setup:LOG_LEVEL_DEBUG];
  #else
    [LinkLogger setup:LOG_LEVEL_INFO];
  #endif
  
  return NSApplicationMain(argc, (const char **)argv);
}
