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
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar", Paths.configDirectory)
  }

  func testConfigDirectoryEmpty() {
    Stage.stubArguments([
      "--config", ""
    ])

    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar", Paths.configDirectory)
  }

  func testConfigDirectoryCustom() {
    Stage.stubArguments([
      "--config", "/dev/null/over/there"
    ])

    XCTAssertEqual("/dev/null/over/there", Stage.configPath)
  }
}
