// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class MACParserTest: XCTestCase {
  func testAbbreviations() {
    let address = MACParser.normalized48("0a:b:60:84::e6")
    XCTAssertEqual("0a:0b:60:84:00:e6", address)
  }

  func testInvalidSuperfluousCharacters() {
    let address = MACParser.normalized48(" X aa:bb/cc!:dd,ee:ff\n")!
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", address)
  }

  func testInvalid() {
    let address = MACParser.normalized48("aa:bb:cc:dd:ee:fg")
    XCTAssertNil(address)
  }

  func test24bits() {
    let address = MACParser.normalized24("aa:bb:cc")
    XCTAssertEqual("aa:bb:cc", address)
  }

  func test24Abbreviations() {
    let address = MACParser.normalized24("0a:b:")
    XCTAssertEqual("0a:0b:00", address)
  }

  func test24Invalid() {
    let address = MACParser.normalized48("0a:bx")
    XCTAssertNil(address)
  }
}
