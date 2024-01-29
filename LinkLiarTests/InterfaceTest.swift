// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class InterfaceTest: XCTestCase {
  func testName () {
    let interface = Interface(bsd: BSD("en0")!,
                              hardMAC: MAC("e0:e0:e0:e0:e0:e0")!,
                              name: "Wow (en)")!
    XCTAssertEqual("Wow (en)", interface.name)
  }

  func testNameWithBSDName () {
    let interface = Interface(bsd: BSD("en0")!,
                              hardMAC: MAC("e0:e0:e0:e0:e0:e0")!,
                              name: "Wow (en0)")!
    XCTAssertEqual("Wow", interface.name)
  }

  func testNameWithBSDNameHighNumber () {
    let interface = Interface(bsd: BSD("en0")!,
                              hardMAC: MAC("e0:e0:e0:e0:e0:e0")!,
                              name: "(en99) Wow")!
    XCTAssertEqual("Wow", interface.name)
  }
}
