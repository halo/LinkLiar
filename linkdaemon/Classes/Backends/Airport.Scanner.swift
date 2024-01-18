// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension Airport {
  ///
  /// Runs the external exectuable `airport` to determine which
  /// Access Points are reachable through the internal Wi-Fi interface.
  ///
  struct Scanner {
    // MARK: - Class Methods

    init(stubOutput: String? = nil) {
      self.stubOutput = stubOutput
    }

    // MARK: - Instance Properties

    lazy var accessPoints: [String: Any]? = {
      do {
        let infoPlistData = command.runData()
          if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
              return dict
          }
      } catch {
        print(error)
      }
      return nil
    }()

    // MARK: - Private Instance Properties

    var stubOutput: String?

    private lazy var output: String = {
      stubOutput ?? command.run()
    }()

    private lazy var command = {
      Command.init(Paths.airportCLI, arguments: ["--scan", "--xml"])
    }()
  }
}
