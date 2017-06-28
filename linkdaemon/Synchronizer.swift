import Foundation

class Synchronizer {

  static func run() {
    for interface in Interfaces.all(async: false) {
      let action = Config.instance.actionForInterface(interface.hardMAC)

      switch action {

      case Interface.Action.ignore:
        continue

      case Interface.Action.original:
        if interface.hasOriginalMAC { continue }
        setMAC(BSDName: interface.BSDName, address: interface.hardMAC)

      case Interface.Action.specify:
        guard let address = Config.instance.addressForInterface(interface.hardMAC) else {
          continue
        }
        if interface.softMAC == address { continue }
        setMAC(BSDName: interface.BSDName, address: address)

      default:
        print("FIXME")
      }

    }
  }

  private static func setMAC(BSDName: String, address: MACAddress) {
    guard address.isValid else {
      Log.info("Cannot apply MAC <\(address.humanReadable)> because it is not valid.")
      return
    }
    Log.info("Setting MAC address <\(address.formatted)> for Interface \(BSDName)...")
    let task = Process()
    task.launchPath = "/usr/bin/sudo"
    task.arguments = ["/sbin/ifconfig", BSDName, "ether", address.formatted]
    task.launch()
  }

}
