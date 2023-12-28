// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigTests: XCTestCase {

  func testDictionaryWithStrings() {
    let dictionary = ["one": "two"]
    let configuration = Config.Reader(dictionary)
    XCTAssertEqual(["one": "two"], configuration.dictionary as! [String: String])
  }

  func testDictionaryWithIntegers() {
    let dictionary = ["one": 1]
    let configuration = Config.Reader(dictionary)
    XCTAssertEqual(["one": 1], configuration.dictionary as! [String: Int])
  }

}
