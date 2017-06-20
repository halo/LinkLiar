struct Configuration {

  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }

  var dictionary: [String: Any]

  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()

}
