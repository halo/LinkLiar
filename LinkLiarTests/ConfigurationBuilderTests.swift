// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigurationBuilderTests: XCTestCase {

  func testRemoveInterfaceSsidOne() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["ssids":
          ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
           "Papershop": "bb:bb:bb:bb:bb:bb"
          ]
        ]
    ])
    let builder = Configuration.Builder(state.configDictionary)
    let dictionary = builder.removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: Any]
    XCTAssertEqual(["ssids"], Array(interfaceDictionary.keys))

    let ssidsDictionary = interfaceDictionary["ssids"] as! [String: String]
    XCTAssertEqual(["Papershop": "bb:bb:bb:bb:bb:bb"], ssidsDictionary)
  }

  func testRemoveInterfaceSsidLast() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["action": "random",
         "ssids":
          ["Coffeeshop": "aa:aa:aa:aa:aa:aa"]
        ]
    ])
    let builder = Configuration.Builder(state.configDictionary)
    let dictionary = builder.removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: Any]
    XCTAssertEqual(["action"], Array(interfaceDictionary.keys))
  }

  func testRemoveInterfaceSsidOnly() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["ssids":
          ["Coffeeshop": "aa:aa:aa:aa:aa:aa"]
        ]
    ])
    let builder = Configuration.Builder(state.configDictionary)
    let dictionary = builder.removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")

    XCTAssertEqual([], Array(dictionary.keys))
  }

}
