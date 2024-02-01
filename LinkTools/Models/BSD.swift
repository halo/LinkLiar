// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

/// Service Set Identifier (aka. Wi-Fi access point name).
///
struct BSD: Identifiable {
  // MARK: - Class Methods

  init?(_ name: String) {
    if name != "en0" &&
       name != "en1" &&
       name != "en2" &&
       name != "en3" &&
       name != "en4" &&
       name != "en5" &&
       name != "en6" &&
       name != "en7" &&
       name != "en8" &&
       name != "en9" &&
       name != "en10" &&
       name != "en11" { return nil }

    // Could be improved with something like the following,
    // but needs testing against Strings like "en00042"
    //
    // if name.range(of: "^en[0-9]+$", options: .regularExpression) == nil {
    //   return nil
    // }

    self.name = name
  }

  // MARK: - Private Class Methods

  private init(validName: String) {
    self.name = validName
  }

  // MARK: - Instance Properties

  let name: String
  var number: Int {
    let numberAsString = name.suffix(from: name.index(name.startIndex, offsetBy: 2))
    return Int(numberAsString) ?? 999
  }

  /// Conforming to `Identifiable`.
  var id: String { name }
}

extension BSD: Comparable {
  static func == (lhs: BSD, rhs: BSD) -> Bool {
    lhs.name == rhs.name
  }

  static func < (lhs: BSD, rhs: BSD) -> Bool {
    lhs.name < rhs.name
  }
}
