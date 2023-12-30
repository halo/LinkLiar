// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigBuilderTests: XCTestCase {

  // MARK: setInterfaceAction

  func testSetInterfaceActionToHideFirstTime() {
    let state = LinkState()
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.setInterfaceAction(interface, action: .hide)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "hide"], interfaceDictionary)
  }

  func testSetInterfaceActionToRandomFirstTime() {
    let state = LinkState()
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    interface.overrideSoftMacInTests = MACAddress("bb:bb:bb:bb:bb:bb")
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.setInterfaceAction(interface, action: .random)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "random", "except": "bb:bb:bb:bb:bb:bb"], interfaceDictionary)
  }

  func testSetInterfaceActionToRandomFirstTimeWithoutSoftMac() {
    let state = LinkState()
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.setInterfaceAction(interface, action: .random)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "random"], interfaceDictionary)
  }

  // MARK: removeInterfaceSsid

  func testRemoveInterfaceSsidOne() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["ssids":
          ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
           "Papershop": "bb:bb:bb:bb:bb:bb"
          ]
        ]
    ])
    let builder = Config.Builder(state.configDictionary)
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
    let builder = Config.Builder(state.configDictionary)
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
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")

    XCTAssertEqual([], Array(dictionary.keys))
  }

  func testResetExceptionAddressFirstTime() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["action": "random"]
    ])
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    interface.overrideSoftMacInTests = MACAddress("bb:bb:bb:bb:bb:bb")
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.testResetExceptionAddress(interface)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "random", "except": "bb:bb:bb:bb:bb:bb"], interfaceDictionary)
  }

  func testResetExceptionAddress() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["action": "random", "except": "aa:aa:aa:aa:aa:aa"]
    ])
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    interface.overrideSoftMacInTests = MACAddress("bb:bb:bb:bb:bb:bb")
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.testResetExceptionAddress(interface)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "random", "except": "bb:bb:bb:bb:bb:bb"], interfaceDictionary)
  }

  func testResetExceptionAddressForNonRandomInterface() {
    let state = LinkState([
      "e1:e1:e1:e1:e1:e1":
        ["action": "ignore"]
    ])
    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
    interface.overrideSoftMacInTests = MACAddress("bb:bb:bb:bb:bb:bb")
    let builder = Config.Builder(state.configDictionary)
    let dictionary = builder.testResetExceptionAddress(interface)

    XCTAssertEqual(["e1:e1:e1:e1:e1:e1"], Array(dictionary.keys))

    let interfaceDictionary = dictionary["e1:e1:e1:e1:e1:e1"] as! [String: String]
    XCTAssertEqual(["action": "ignore"], interfaceDictionary)
  }
}
