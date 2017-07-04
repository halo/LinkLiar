struct Configuration {

  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }

  var dictionary: [String: Any]

  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()

  func actionForInterface(_ hardMAC: MACAddress) -> Interface.Action {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else {
      return Interface.Action.undefined
    }

    guard let actionName = interfaceDictionary["action"] else {
      return Interface.Action.undefined
    }

    return Interface.Action(rawValue: actionName) ?? .undefined
  }

  func addressForInterface(_ hardMAC: MACAddress) -> MACAddress? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else {
      return nil
    }

    guard let rawAddress = interfaceDictionary["address"] else {
      return nil
    }

    return MACAddress(rawAddress)
  }

  func addressForDefaultInterface() -> MACAddress? {
    guard let interfaceDictionary = dictionary["default"] as? [String: String] else {
      return nil
    }

    guard let rawAddress = interfaceDictionary["address"] else {
      return nil
    }

    return MACAddress(rawAddress)
  }

  func exceptionAddressForInterface(_ hardMAC: MACAddress) -> MACAddress? {
    guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else {
      return nil
    }

    guard let rawAddress = interfaceDictionary["except"] else {
      return nil
    }

    return MACAddress(rawAddress)
  }

  func actionForDefaultInterface() -> Interface.Action {
    guard let interfaceDictionary = dictionary["default"] as? [String: String] else {
      return Interface.Action.undefined
    }

    guard let actionName = interfaceDictionary["action"] else {
      return Interface.Action.undefined
    }

    return Interface.Action(rawValue: actionName) ?? .undefined
  }
}


