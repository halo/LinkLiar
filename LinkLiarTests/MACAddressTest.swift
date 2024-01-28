// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class MACAddressTest: XCTestCase {
  func testAbbreviations() {
    let mac = MACAddress("0a:b:60:84::e6")!
    XCTAssertEqual("0a:0b:60:84:00:e6", mac.address)
  }

  func testInvalidSuperfluousCharacters() {
    let mac = MACAddress(" X aa:bb/cc!:dd,ee:ff\n")!
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", mac.address)
  }

  func testInvalid() {
    let mac = MACAddress("aa:bb:cc:dd:ee:fg")
    XCTAssertNil(mac)
  }
}
