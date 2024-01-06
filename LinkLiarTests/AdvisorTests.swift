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
    let interface = Interface("e1:e1:e1:e1:e1:e1")
    interface.overrideSoftMacInTests = MACAddress("e2:e2:e2:e2:e2:e2")
    let arbiter = Config.Arbiter(config: config, hardMAC: interface.hardMAC)
    arbiter.overrideAddressInTests = MACAddress("aa:aa:aa:aa:aa:aa")
    let advisor = Advisor(interface: interface, arbiter: arbiter)

    let expectedAddress = MACAddress("aa:aa:aa:aa:aa:aa")
    XCTAssertEqual(expectedAddress, advisor.addressForStandard)
  }

  func testRandomWhenAlreadyRandom() {
    let dictionary = [
      "e1:e1:e1:e1:e1:e1":
        ["action": "random"]
    ]
    let config = Config.Reader(dictionary)
    let interface = Interface("e1:e1:e1:e1:e1:e1")
    interface.overrideSoftMacInTests = MACAddress("00:03:93:e2:e2:e2")
    let arbiter = Config.Arbiter(config: config, hardMAC: interface.hardMAC)
    arbiter.overrideAddressInTests = MACAddress("aa:aa:aa:aa:aa:aa")
    let advisor = Advisor(interface: interface, arbiter: arbiter)

    XCTAssertNil(advisor.addressForStandard)
  }
}
