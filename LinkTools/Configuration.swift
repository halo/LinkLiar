struct Configuration {

  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }

  var dictionary: [String: Any]

  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()

  func actionForInterface(_ hardMAC: String) -> Interface.Action {
    guard let interfaceDictionary = dictionary[hardMAC] as? [String: String] else {
      return Interface.Action.undefined
    }

    guard let actionName = interfaceDictionary["action"] else {
      return Interface.Action.undefined
    }

    return Interface.Action(rawValue: actionName) ?? .undefined
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


