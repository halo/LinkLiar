// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigurationPolicyTests: XCTestCase {

  func testAccessPointsInvalidDataType() {
    let dictionary = ["ssids:aa:aa:aa:bb:bb:bb": "bad"] as [String: String]
    let policy = Configuration.Policy("aa:aa:aa:bb:bb:bb", dictionary: dictionary)
    XCTAssertEqual([], policy.accessPoints)
  }

  func testAccessPoints() {
    let dictionary = ["ssids:aa:aa:aa:aa:aa:aa":
                        ["Coffeeshop": "bb:bb:bb:bb:bb:bb",
                         "Invalid MAC": "XX:bb:bb:bb:bb:bb",
                         "Empty MAC": "",
                         "": "ff:ff:ff:ff:ff:ff",
                         "Papershop": "cc:cc:cc:cc:cc:cc"],
    ] as [String: [String: String]]
    let policy = Configuration.Policy("aa:aa:aa:aa:aa:aa", dictionary: dictionary)
    let accessPoints = policy.accessPoints
    XCTAssertEqual(2, accessPoints.count)

    let accessPoint1 = accessPoints.first!
    XCTAssertEqual("Coffeeshop", accessPoint1.ssid)
    XCTAssertEqual(MACAddress("bb:bb:bb:bb:bb:bb"), accessPoint1.softMAC)

    let accessPoint2 = accessPoints.last!
    XCTAssertEqual("Papershop", accessPoint2.ssid)
    XCTAssertEqual(MACAddress("cc:cc:cc:cc:cc:cc"), accessPoint2.softMAC)
  }

}
