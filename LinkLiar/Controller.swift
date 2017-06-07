import Foundation

class Controller: NSObject {

  static func authorize(_ sender: Any) {
    Log.debug("Looking up helper version")
    //let intercom = Intercom()
    Intercom.helperVersion(reply: {
      version in
      if (version == nil) {
        // TODO Compare SemVer
        Log.debug("helper does not seem to say much")
        Elevator().install()
      } else {
        Log.debug("helper is helpful")
        Log.debug("\(version)")
      }
      // Elevator().bless()

    })
  }
}
