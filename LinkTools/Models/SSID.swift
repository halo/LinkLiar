// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

/// Service Set Identifier (aka. Wi-Fi access point name).
///
struct SSID: Identifiable {
  // MARK: - Class Methods

  init?(_ name: String) {
    if name.isEmpty { return nil }
    if name.count > 32 { return nil }

    self.name = name
  }

  // MARK: - Private Class Methods

  private init(validName: String) {
    self.name = validName
  }

  // MARK: - Instance Properties

  let name: String

  /// Conforming to `Identifiable`.
  var id: String { name }
}

extension SSID: Comparable {
  static func == (lhs: SSID, rhs: SSID) -> Bool {
    lhs.name == rhs.name
  }

  static func < (lhs: SSID, rhs: SSID) -> Bool {
    lhs.name < rhs.name
  }
}
