// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class AdvisorTests: XCTestCase {
  func testRandom() {
    let dictionary = [
      "e1:e1:e1:e1:e1:e1":
        ["action": "random"]
    ]
    let config = Config.Reader(dictionary)
    let interface = Interface(bsd: BSD("en0")!,
                              hardMAC: MAC("e1:e1:e1:e1:e1:e1")!,
                              stubSoftMAC: MAC("e2:e2:e2:e2:e2:e2"))!
    let arbiter = Config.Arbiter(config: config, hardMAC: interface.hardMAC)
    arbiter.stubAddressInTests = MAC("aa:aa:aa:aa:aa:aa")
    let advisor = Advisor(interface: interface, arbiter: arbiter)

    let expectedAddress = MAC("aa:aa:aa:aa:aa:aa")
    XCTAssertEqual(expectedAddress, advisor.address)
  }

  func testRandomWhenAlreadyRandom() {
    let dictionary = [
      "e1:e1:e1:e1:e1:e1":
        ["action": "random"]
    ]
    let config = Config.Reader(dictionary)
    let interface = Interface(bsd: BSD("en0")!,
                              hardMAC: MAC("e1:e1:e1:e1:e1:e1")!,
                              stubSoftMAC: MAC("00:03:93:e2:e2:e2"))!
    let arbiter = Config.Arbiter(config: config, hardMAC: interface.hardMAC)
    arbiter.stubAddressInTests = MAC("aa:aa:aa:aa:aa:aa")
    let advisor = Advisor(interface: interface, arbiter: arbiter)

    XCTAssertNil(advisor.address)
  }
}
