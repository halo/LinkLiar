// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class PopularVendorsTests: XCTestCase {
  func testFind() {
    let vendor = PopularVendors.find("dlink")

    XCTAssertEqual("D-link", vendor?.name)
    XCTAssertEqual(82, vendor?.prefixCount)
  }
}
