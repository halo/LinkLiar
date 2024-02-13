// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class MACVendorsTest: XCTestCase {
  func testLoad() {
    let expectation = XCTestExpectation(description: "asd")

    MACVendors.load({ dictionary in
      let name = MACVendors.name(OUI("b8:c2:53")!)
      XCTAssertEqual("Juniper Networks", name)
      expectation.fulfill()
    })

    let result = XCTWaiter.wait(for: [expectation], timeout: 1.0)
    XCTAssertEqual(result, .completed)
  }
}
