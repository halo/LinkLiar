import Foundation

class Controller: NSObject {

  static func authorize(_ sender: Any) {
    Log.debug("Looking up helper version")
    Elevator().install()

  }
}
