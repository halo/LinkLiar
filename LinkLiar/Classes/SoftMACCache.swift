struct SoftMACCache {

  static func remember(BSDName: String, address: String) {
    addresses[BSDName] = address
  }

  static func address(BSDName: String) -> String? {
    return addresses[BSDName]
  }

  private static var addresses: [String: String] = [:]

}
