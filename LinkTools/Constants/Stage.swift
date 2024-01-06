// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class Stage {
  // MARK: Class Properties

  static var configPath: String? {
    Log.debug("\(CommandLine.arguments)")
    Log.debug("\(options)")
    return options[Self.Argument.config.rawValue]
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
    case 3:
      return [
        arguments[1]: arguments[2]
      ]
    case 5:
      return [
        arguments[1]: arguments[2],
        arguments[3]: arguments[4]
      ]
    case 7:
      return [
        arguments[1]: arguments[2],
        arguments[3]: arguments[4],
        arguments[5]: arguments[6]
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
