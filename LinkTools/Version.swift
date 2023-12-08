// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

struct Version {

  // MARK: Class Methods

  init(_ version: String) {
    let v = version.components(separatedBy: ".") as Array

    major = Int(v[0])!
    minor = Int(v[1])!
    patch = Int(v[2])!
  }

  // MARK: Instance Properties

  var major: Int
  var minor: Int
  var patch: Int

  var formatted: String {
    if major == 0 && minor == 0 && patch == 0 { return "unknown" }

    return "\(self.major).\(self.minor).\(self.patch)"
  }

  // MARK: Instance Methods

  func isCompatible(with: Version) -> Bool {
    return self.major == with.major && self.minor == with.minor
  }

}
