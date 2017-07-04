import Foundation

class Synchronizer {

  static func run() {
    for interface in Interfaces.all(async: false) {
      let action = Config.instance.actionForInterface(interface.hardMAC)

      switch action {
      case .ignore:    Log.debug("Dutifully ignoring Interface \(interface.BSDName)")
      case .original:  originalize(interface)
      case .specify:   specify(interface)
      case .random:    randomize(interface)
      case .undefined: defaultize(interface)
      }
    }
  }

  static func mayReRandomize() {
    for interface in Interfaces.all(async: false) {
      var action = Config.instance.actionForInterface(interface.hardMAC)
      if (action == .undefined) {
        Log.debug("Interface \(interface.BSDName) has no action defined, falling back to default.")
        action = Config.instance.actionForDefaultInterface()
      }

      guard action == .random else {
        Log.debug("Not re-randomizing \(interface.BSDName) because it is not defined to be random at all.")
        return
      }
      Log.debug("Taking the chance to re-randomize \(interface.BSDName)")
      setMAC(BSDName: interface.BSDName, address: RandomMACs.popular())
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
    Log.debug("Giving Interface \(interface.BSDName) back its original hardware MAC.")
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

  private static func specifyFromDefault(_ interface: Interface) {
    guard let address = Config.instance.addressForDefaultInterface() else {
      return
    }
    if interface.softMAC == address {
      Log.debug("Interface \(interface.BSDName) with hardMAC \(interface.hardMAC.formatted) and softMAC \(interface.softMAC.formatted) is already set to softMAC \(address.formatted) - skipping")
      return
    }
    setMAC(BSDName: interface.BSDName, address: address)
  }

  private static func defaultize(_ interface: Interface) {
    let action = Config.instance.actionForDefaultInterface()

    switch action {
    case .ignore:
      Log.debug("Ignoring unknown Interface \(interface.BSDName) because that is set as default.")
    case .original:
      Log.debug("Originalizing unknown Interface \(interface.BSDName) because that is set as default.")
      originalize(interface)
    case .specify:
      Log.debug("Specifying unknown Interface \(interface.BSDName) because that is set as default.")
      specifyFromDefault(interface)
    case .random:
      Log.debug("Randomizing unknown Interface \(interface.BSDName) because that is set as default.")
      randomize(interface)
    case .undefined:
      Log.debug("Randomizing unknown Interface \(interface.BSDName) because no default is specified and that's a good default.")
      randomize(interface)
    }
  }

  private static func setMAC(BSDName: String, address: MACAddress) {
    guard address.isValid else {
      Log.info("Cannot apply MAC <\(address.humanReadable)> because it is not valid.")
      return
    }
    Log.info("Setting MAC address <\(address.formatted)> for Interface \(BSDName)...")
    let task = Process()
    task.launchPath = "/sbin/ifconfig"
    task.arguments = [BSDName, "ether", address.formatted]
    task.launch()
  }

}
