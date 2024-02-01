// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class BSDTest: XCTestCase {
  func testNumber() {
    XCTAssertEqual(0, BSD("en0")!.number)
    XCTAssertEqual(1, BSD("en1")!.number)
    XCTAssertEqual(9, BSD("en9")!.number)
    XCTAssertEqual(10, BSD("en10")!.number)
    XCTAssertEqual(11, BSD("en11")!.number)
  }
}
