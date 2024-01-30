// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

/// Checks a potential MAC address for validity and normalizes it.
///
struct MACAnonymizer {
  // MARK: - Class Methods

  static func anonymize(_ input: MAC, stubUserDefaults: UserDefaults = .standard) -> String {
    self.init(input, userDefaults: stubUserDefaults).anonymous
  }

  // MARK: - Private Class Methods

  private init(_ input: MAC, userDefaults: UserDefaults = .standard) {
    self.input = input
    self.userDefaults = userDefaults
  }

  // MARK: - Instance Properties

  var anonymous: String {
    guard let seedAddress = MAC(seed) else {
      return "??:??:??:??:??:??"
    }

    let plaintext = input.integers
    let key = seedAddress.integers
    let ciphertext = plaintext.enumerated().map { ($1 + key[$0]) % 16 }
    let anonmousAddress = ciphertext.map { String($0, radix: 16) }.joined()

    guard let output = MAC(anonmousAddress) else {
      return "??:??:??:??:??:??"
    }

    return output.address
  }

  /// Fetches the system-wide persisted anonymization seed.
  /// Persists a new one if there is none.
  ///
  private var seed: String {
    if let knownSeed = userDefaults.string(forKey: seedKey) {
      return knownSeed
    } else {
      let newSeed = generateSeed()
      userDefaults.setValue(newSeed, forKey: seedKey)
      return newSeed
    }
  }

  /// Generates a completely random MAC address.
  ///
  func generateSeed() -> String {
    [
      String(Int.random(in: 0..<256), radix: 16, uppercase: false),
      String(Int.random(in: 0..<256), radix: 16, uppercase: false),
      String(Int.random(in: 0..<256), radix: 16, uppercase: false),
      String(Int.random(in: 0..<256), radix: 16, uppercase: false),
      String(Int.random(in: 0..<256), radix: 16, uppercase: false),
      String(Int.random(in: 0..<256), radix: 16, uppercase: false)
    ].joined()
  }

  private let input: MAC
  private let userDefaults: UserDefaults
  private let seedKey = "seed"
}
