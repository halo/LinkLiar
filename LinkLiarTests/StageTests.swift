// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class StageTests: XCTestCase {
  override func setUp() {
    Stage.resetArguments()
  }

  // MARK: configPath

  func testConfigPathDefault() {
    XCTAssertNil(Stage.configPath)
  }

  func testConfigPathCustom() {
    Stage.stubArguments(["--config", "/dev/null/over/here"])

    XCTAssertEqual("/dev/null/over/here", Stage.configPath)
  }
}
