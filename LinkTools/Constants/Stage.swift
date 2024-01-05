// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Stage {
  // MARK: Class Properties

  static var configPath: String? {
    options[Self.Argument.config.rawValue]
  }

  // MARK: Private Class Properties

  ///
  /// Keeping it simple for now, the CLI arguments need to be presented in tuples.
  ///
  /// ## Example:
  ///
  /// ```swift
  /// --some thing --one more
  /// ```
  ///
  private static var options: [String: String] {
    switch arguments.count {
    case 2:
      return [
        arguments[0]: arguments[1]
      ]
    case 4:
      return [
        arguments[0]: arguments[1],
        arguments[2]: arguments[3]
      ]

    default:
      return [:]
    }
  }

  // MARK: Private Class Methods

  static func stubArguments(_ newArguments: [String]) {
    arguments = newArguments
  }

  static func resetArguments() {
    arguments = CommandLine.arguments
  }

  ///
  /// We keep this mutable for easier unit testing.
  ///
  private static var arguments: [String] = CommandLine.arguments
}

extension Stage {
  enum Argument: String {
    case config = "--config"
  }
}
