// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class PathsTests: XCTestCase {
  override func setUp() {
    Stage.resetArguments()
  }

  // MARK: configDirectory

  func testConfigDirectoryDefault() {
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar/config.json", Paths.configFile)
  }

  func testConfigDirectoryEmpty() {
    Stage.stubArguments([
      "--config", ""
    ])

    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar/config.json", Paths.configFile)
  }

  func testConfigDirectoryCustom() {
    Stage.stubArguments([
      "--config", "/dev/null/over/there.json"
    ])

    XCTAssertEqual("/dev/null/over/there.json", Paths.configFile)
  }
}
