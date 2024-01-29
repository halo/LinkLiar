// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigurationPolicyTests: XCTestCase {

  func testInvalidRoot() {
    let dictionary = ["aa:aa:aa:bb:bb:bb": "bad"] as [String: String]
    let policy = Config.Policy("aa:aa:aa:bb:bb:bb", dictionary: dictionary)
    XCTAssertEqual([], policy.accessPoints)
  }

  func testInvalidAccessPointsInvalid() {
    let dictionary = [
      "e1:e1:e1:e1:e1:e1":
        ["ssids": "what is this?"]
    ] as [String: [String: String]]
    let policy = Config.Policy("aa:aa:aa:bb:bb:bb", dictionary: dictionary)
    XCTAssertEqual([], policy.accessPoints)
  }

  func testAccessPoints() {
    let dictionary = [
      "e1:e1:e1:e1:e1:e1":
        ["ssids":
          ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
           "Invalid MAC": "xx:xx:xx:xx:xx:xx",
           "Empty MAC": "",
           "": "ff:ff:ff:ff:ff:ff",
           "Papershop": "bb:bb:bb:bb:bb:bb"
          ]
        ]
    ] as [String: [String: [String: String]]]
    let policy = Config.Policy("e1:e1:e1:e1:e1:e1", dictionary: dictionary)
    let accessPoints = policy.accessPoints
    XCTAssertEqual(2, accessPoints.count)

    let accessPoint1 = accessPoints.first!
    XCTAssertEqual("Coffeeshop", accessPoint1.ssid)
    XCTAssertEqual(MAC("aa:aa:aa:aa:aa:aa"), accessPoint1.softMAC)

    let accessPoint2 = accessPoints.last!
    XCTAssertEqual("Papershop", accessPoint2.ssid)
    XCTAssertEqual(MAC("bb:bb:bb:bb:bb:bb"), accessPoint2.softMAC)
  }

}
