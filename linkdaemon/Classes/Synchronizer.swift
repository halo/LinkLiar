import Foundation

class Synchronizer {

  static func run() {
    for interface in Interfaces.all(async: false) {
      let action = Config.instance.actionForInterface(interface.hardMAC)

      switch action {
      case Interface.Action.ignore:    continue
      case Interface.Action.original:  originalize(interface)
      case Interface.Action.specify:   specify(interface)
      case Interface.Action.random:    randomize(interface)
      case Interface.Action.undefined: Log.error("Don't know what to do with Interface \(interface.BSDName)")
      }
    }
  }

  private static func specify(_ interface: Interface) {
    guard let address = Config.instance.addressForInterface(interface.hardMAC) else {
      return
    }
    if interface.softMAC == address {
      Log.debug("Interface \(interface.BSDName) with hardMAC \(interface.hardMAC.formatted) and softMAC \(interface.softMAC.formatted) is already set to softMAC \(address.formatted) - skipping")
      return
    }
    setMAC(BSDName: interface.BSDName, address: address)
  }

  private static func originalize(_ interface: Interface) {
    if interface.hasOriginalMAC {
      Log.debug("Skipping Interface \(interface.BSDName), because it currently has its original MAC address.")
      return
    }
    setMAC(BSDName: interface.BSDName, address: interface.hardMAC)
  }

  private static func randomize(_ interface: Interface) {
    Log.debug("Interface \(interface.BSDName) is specified to be randomized.")

    if interface.hasOriginalMAC {
      Log.debug("Randomizing Interface \(interface.BSDName) because it currently has its original MAC address.")
      setMAC(BSDName: interface.BSDName, address: RandomMACs.popular())
    }

    guard let undesiredAddress = Config.instance.exceptionAddressForInterface(interface.hardMAC) else {
      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random and no undesired address has been specified.")
      return
    }

    if undesiredAddress.isInvalid {
      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random and the undesired address is invalidly specified.")
      return
    }

    if interface.softMAC == undesiredAddress {
      Log.debug("Randomizing Interface \(interface.BSDName) because it currently has the undesired address \(undesiredAddress.humanReadable).")
      setMAC(BSDName: interface.BSDName, address: RandomMACs.popular())
    } else {
      Log.debug("Skipping randomization of Interface \(interface.BSDName) because it is already random does not have the undesired address \(undesiredAddress.humanReadable).")
      return
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
