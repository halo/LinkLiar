// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class ConfigBuilderTests: XCTestCase {
  //
  //  // MARK: setInterfaceAction
  //
  //  func testSetInterfaceActionToHideFirstTime() {
  //    let input: [String: Any] = [:]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: .hide)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["action": "hide"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceActionToRandomFirstTime() {
  //    let input: [String: Any] = [:]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    interface.overrideSoftMacInTests = MAC("bb:bb:bb:bb:bb:bb")
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: .random)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1":
  //                      ["action": "random",
  //                       "except": "bb:bb:bb:bb:bb:bb"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceActionToRandomFirstTimeWithoutSoftMac() {
  //    let input: [String: Any] = [:]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: .random)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["action": "random"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceActionToNothingFirstTime() {
  //    let input: [String: Any] = [:]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    interface.overrideSoftMacInTests = MAC("bb:bb:bb:bb:bb:bb")
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: nil)
  //
  //    let expected: [String: Any] = [:]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceActionToNothingRemoving() {
  //    let input = ["e1:e1:e1:e1:e1:e1": ["action": "random"]]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: nil)
  //
  //    let expected: [String: Any] = [:]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceActionToNothingModifying() {
  //    let input = ["e1:e1:e1:e1:e1:e1": ["action": "random", "address": "aa:aa:aa:aa:aa:aa"]]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    let output = Config.Builder(input)
  //      .setInterfaceAction(interface, action: nil)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["address": "aa:aa:aa:aa:aa:aa"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  // MARK: setInterfaceAddress
  //
  //  func testSetInterfaceAddressFirstTime() {
  //    let input: [String: Any] = [:]
  //    let output = Config.Builder(input)
  //      .setInterfaceAddress("e1:e1:e1:e1:e1:e1", address: "aa:aa:aa:aa:aa:aa")
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["address": "aa:aa:aa:aa:aa:aa"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testSetInterfaceAddressModifying() {
  //    let input = [ "e1:e1:e1:e1:e1:e1": ["address": "aa:aa:aa:aa:aa:aa",
  //                                        "except": "bb:bb:bb:bb:bb:bb"]]
  //    let output = Config.Builder(input)
  //      .setInterfaceAddress("e1:e1:e1:e1:e1:e1", address: "cc:cc:cc:cc:cc:cc")
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["address": "cc:cc:cc:cc:cc:cc",
  //                                          "except": "bb:bb:bb:bb:bb:bb"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  // MARK: setFallbackInterfaceAction
  //
  //  func testSetFallbackInterfaceActionToHideFirstTime() {
  //    let input: [String: Any] = [:]
  //    let output = Config.Builder(input).setFallbackInterfaceAction(.hide)
  //
  //    let expected = ["default": ["action": "hide"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //
  //  func testSetFallbackInterfaceActionToNothingRemoving() {
  //    let input = ["default": ["action": "random"]]
  //    let output = Config.Builder(input).setFallbackInterfaceAction(nil)
  //
  //    let expected: [String: Any] = [:]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //
  //  // MARK: resetExceptionAddress
  //
  //  func testResetExceptionAddressFirstTime() {
  //    let input: [String: Any] = [:]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    interface.overrideSoftMacInTests = MAC("bb:bb:bb:bb:bb:bb")
  //    let output = Config.Builder(input)
  //      .resetExceptionAddress(interface)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["except": "bb:bb:bb:bb:bb:bb"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testResetExceptionAddressInvalid() {
  //    let input = ["e1:e1:e1:e1:e1:e1": ["action": "random"]]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    interface.overrideSoftMacInTests = MAC("xx:xx:xx:xx:xx:xx")
  //    let output = Config.Builder(input)
  //      .resetExceptionAddress(interface)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["action": "random"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testResetExceptionAddressModifying() {
  //    let input = ["e1:e1:e1:e1:e1:e1": ["action": "random",
  //                                       "except": "aa:aa:aa:aa:aa:aa",
  //                                       "ssids": ["Coffeeshop": "bb:bb:bb:bb:bb:bb"]]]
  //    let interface = Interface(BSDName: "en0", displayName: "", kind: "", hardMAC: "e1:e1:e1:e1:e1:e1", async: false)
  //    interface.overrideSoftMacInTests = MAC("bb:bb:bb:bb:bb:bb")
  //    let output = Config.Builder(input)
  //      .resetExceptionAddress(interface)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["action": "random",
  //                                          "except": "bb:bb:bb:bb:bb:bb",
  //                                          "ssids": ["Coffeeshop": "bb:bb:bb:bb:bb:bb"]]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  // MARK: addInterfaceSsid
  //
  //  func testAddInterfaceSsidFirstTime() {
  //    let input: [String: Any] = [:]
  //    let accessPointPolicy = Config.AccessPointPolicy(ssid: "Skyshop", softMAC: "cc:cc:cc:cc:cc:cc")
  //    let output = Config.Builder(input)
  //      .addInterfaceSsid("e1:e1:e1:e1:e1:e1", accessPointPolicy: accessPointPolicy)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1":
  //                      ["ssids":
  //                        ["Skyshop": "cc:cc:cc:cc:cc:cc"]]
  //    ]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testAddInterfaceSsidEmpty() {
  //    let input = ["e1:e1:e1:e1:e1:e1":
  //                  ["ssids": []]
  //    ]
  //    let accessPointPolicy = Config.AccessPointPolicy(ssid: "Skyshop", softMAC: "cc:cc:cc:cc:cc:cc")
  //    let output = Config.Builder(input)
  //      .addInterfaceSsid("e1:e1:e1:e1:e1:e1", accessPointPolicy: accessPointPolicy)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1":
  //                      ["ssids":
  //                        ["Skyshop": "cc:cc:cc:cc:cc:cc"]]
  //    ]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testAddInterfaceSsid() {
  //    let input = ["e1:e1:e1:e1:e1:e1":
  //                  ["ssids":
  //                    ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
  //                     "Papershop": "bb:bb:bb:bb:bb:bb"
  //                    ]
  //                  ]
  //    ]
  //    let accessPointPolicy = Config.AccessPointPolicy(ssid: "Skyshop", softMAC: "cc:cc:cc:cc:cc:cc")
  //    let output = Config.Builder(input)
  //      .addInterfaceSsid("e1:e1:e1:e1:e1:e1", accessPointPolicy: accessPointPolicy)
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1":
  //                      ["ssids":
  //                        ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
  //                         "Papershop": "bb:bb:bb:bb:bb:bb",
  //                         "Skyshop": "cc:cc:cc:cc:cc:cc"]
  //                      ]
  //    ]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  // MARK: removeInterfaceSsid
  //
  //  func testRemoveInterfaceSsidOne() {
  //    let input = ["e1:e1:e1:e1:e1:e1":
  //                  ["ssids":
  //                    ["Coffeeshop": "aa:aa:aa:aa:aa:aa",
  //                     "Papershop": "bb:bb:bb:bb:bb:bb"
  //                    ]
  //                  ]
  //    ]
  //    let output = Config.Builder(input)
  //      .removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1":
  //                      ["ssids":
  //                        ["Papershop": "bb:bb:bb:bb:bb:bb"]
  //                      ]
  //    ]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testRemoveInterfaceSsidLast() {
  //    let input = [
  //      "e1:e1:e1:e1:e1:e1":
  //        ["action": "random",
  //         "ssids":
  //          ["Coffeeshop": "aa:aa:aa:aa:aa:aa"]
  //        ]
  //    ]
  //    let output = Config.Builder(input)
  //      .removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")
  //
  //    let expected = ["e1:e1:e1:e1:e1:e1": ["action": "random"]]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  func testRemoveInterfaceSsidOnly() {
  //    let input = [
  //      "e1:e1:e1:e1:e1:e1":
  //        ["ssids":
  //          ["Coffeeshop": "aa:aa:aa:aa:aa:aa"]
  //        ]
  //    ]
  //    let output = Config.Builder(input)
  //      .removeInterfaceSsid("e1:e1:e1:e1:e1:e1", ssid: "Coffeeshop")
  //
  //    let expected: [String: Any] = [:]
  //    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  //  }
  //
  //  // MARK: addVendor

  func testAddVendor() {
    let input = [
      "vendors":
        ["3com", "apple"]
    ]
    let vendor = Vendor(id: "acme", name: "")
    let output = Config.Builder(input).addVendor(vendor)

    let expected = ["vendors": ["3com", "acme", "apple"]]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  func testAddVendorDuplicates() {
    let input = [
      "vendors":
        ["3com", "apple"]
    ]
    let vendor = Vendor(id: "apple", name: "", prefixes: [])
    let output = Config.Builder(input).addVendor(vendor)

    let expected = ["vendors": ["3com", "apple"]]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  // MARK: removeVendor

  func testRemoveVendor() {
    let input = [
      "vendors":
        ["3com", "apple"]
    ]
    let vendor = Vendor(id: "apple", name: "", prefixes: [])
    let output = Config.Builder(input).removeVendor(vendor)

    let expected = ["vendors": ["3com"]]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  func testRemoveVendorDuplicates() {
    let input = [
      "vendors":
        ["3com", "apple", "apple"]
    ]
    let vendor = Vendor(id: "apple", name: "", prefixes: [])
    let output = Config.Builder(input).removeVendor(vendor)

    let expected = ["vendors": ["3com"]]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  func testRemoveVendorLast() {
    let input = [
      "vendors":
        ["3com"]
    ]
    let vendor = Vendor(id: "3com", name: "", prefixes: [])
    let output = Config.Builder(input).removeVendor(vendor)

    let expected: [String: Any] = [:]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  func testAddAllVendors() {
    let input = [
      "vendors":
        ["3com"]
    ]
    let output = Config.Builder(input).addAllVendors()

    let expected = ["vendors":
                      [
                        "3com",
                        "apple",
                        "aruba",
                        "asustek",
                        "azurewave",
                        "china",
                        "cisco",
                        "cocacola",
                        "dell",
                        "dlink",
                        "eero",
                        "ericsson",
                        "extreme",
                        "google",
                        "hangzhou",
                        "hewlett",
                        "hp",
                        "htc",
                        "huawei",
                        "ibm",
                        "intel",
                        "lg",
                        "microsoft",
                        "motorola",
                        "murata",
                        "netgear",
                        "new",
                        "nintendo",
                        "nokia",
                        "samsung",
                        "sichuan",
                        "silicon",
                        "sony",
                        "texas",
                        "tplink",
                        "vantiva",
                        "vivo",
                        "xiaomi",
                        "zte",
                        "zyxel"
                      ]
    ]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }

  func testRemoveAllVendors() {
    let input = [
      "vendors":
        ["3com"]
    ]
    let output = Config.Builder(input).removeAllVendors()

    let expected: [String: Any] = [:]
    XCTAssertEqual(expected as NSDictionary, output as NSDictionary)
  }
}
