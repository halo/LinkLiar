/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import XCTest
@testable import LinkLiar

class ConfigurationPrefixesTests: XCTestCase {

  // #prefixesForDefaultInterface

  func testPrefixesForDefaultWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertTrue(configuration.prefixes.prefixesForDefaultInterface.isEmpty)
  }

  func testPrefixesForDefaultWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.prefixes.prefixesForDefaultInterface.isEmpty)
  }

  func testPrefixesForDefaultWithAtLeastOneValidPrefix() {
    let dictionary = ["default": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixes.prefixesForDefaultInterface)
  }

  func testPrefixesForDefaultWithWhitespace() {
    let dictionary = ["default": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixes.prefixesForDefaultInterface)
  }

  // #prefixesForInterface

  func testPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.prefixesForInterface(address).isEmpty)
  }

  func testPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.prefixesForInterface(address).isEmpty)
  }

  func testPrefixesForInterfaceWithAtLeastOneValidPrefix() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixes.prefixesForInterface(address))
  }

  func testPrefixesForInterfaceWithWhitespace() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixes.prefixesForInterface(address))
  }

  // #vendorsForDefaultInterface

  func testVendorsForDefaultWhenNothingSpecified() throws {
    let configuration = Configuration(dictionary: [:])
    let vendors = configuration.prefixes.vendorsForDefaultInterface
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenInvalid() {
    let dictionary = ["default": ["vendors": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendorsForDefaultInterface
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenVendorsAndPrefixesEmpty() {
    let dictionary = ["default": ["vendors": "", "prefixes": ""]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendorsForDefaultInterface
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenPrefixesExist() {
    let dictionary = ["default": ["vendors": "", "prefixes": "aa:bb:cc"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.prefixes.vendorsForDefaultInterface.isEmpty)
  }

  func testVendorsForDefaultWithAtLeastOneValidVendor() throws {
    let dictionary = ["default": ["vendors": "ibm,fruit-tree,3com"]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendorsForDefaultInterface
    XCTAssertEqual(2, vendors.count)
    let ibm = try XCTUnwrap(vendors[0])
    let threecom = try XCTUnwrap(vendors[1])
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("IBM", ibm.name)
    XCTAssertEqual(MACPrefix("3440B5"), ibm.prefixes.first)
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3Com", threecom.name)
    XCTAssertEqual(MACPrefix("006008"),threecom.prefixes.first)
  }

  func testVendorsForDefaultWithWhitespace() throws {
    let dictionary = ["default": ["vendors": "  ibm  ,fruit-tree,3com "]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendorsForDefaultInterface
    XCTAssertEqual(2, vendors.count)
    let ibm = try XCTUnwrap(vendors[0])
    let threecom = try XCTUnwrap(vendors[1])
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("IBM", ibm.name)
    XCTAssertEqual(MACPrefix("3440B5"), ibm.prefixes.first)
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3Com", threecom.name)
    XCTAssertEqual(MACPrefix("006008"),threecom.prefixes.first)
  }

  // #vendorsForInterface

  func testVendorsForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let vendors = configuration.prefixes.vendorsForInterface(address)
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForInterfaceWhenInvalid() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["vendors": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let vendors = configuration.prefixes.vendorsForInterface(address)
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForInterfaceWhenVendorsAndPrefixesEmpty() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["vendors": "", "prefixes": ""]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let vendors = configuration.prefixes.vendorsForInterface(address)
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForInterfaceWhenPrefixesExist() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["vendors": "", "prefixes": "dd:dd:dd"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.vendorsForInterface(address).isEmpty)
  }

  func testVendorsForInterfaceWithAtLeastOneValidPrefix() throws {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["vendors": "ibm,fruit-tree,3com"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let vendors = configuration.prefixes.vendorsForInterface(address)
    XCTAssertEqual(2, vendors.count)
    let ibm = try XCTUnwrap(vendors[0])
    let threecom = try XCTUnwrap(vendors[1])
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("IBM", ibm.name)
    XCTAssertEqual(MACPrefix("3440B5"), ibm.prefixes.first)
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3Com", threecom.name)
    XCTAssertEqual(MACPrefix("006008"),threecom.prefixes.first)
  }

  func testVendorsForInterfaceWithWhitespace() throws {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["vendors": "  ibm  ,fruit-tree,3com "]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let vendors = configuration.prefixes.vendorsForInterface(address)
    XCTAssertEqual(2, vendors.count)
    let ibm = try XCTUnwrap(vendors[0])
    let threecom = try XCTUnwrap(vendors[1])
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("IBM", ibm.name)
    XCTAssertEqual(MACPrefix("3440B5"), ibm.prefixes.first)
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3Com", threecom.name)
    XCTAssertEqual(MACPrefix("006008"),threecom.prefixes.first)
  }

  // #calculatedPrefixesForInterface

  func testCalculatedPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let prefixes = configuration.prefixes.calculatedPrefixesForInterface(address)
    XCTAssertEqual(MACPrefix("000393"), prefixes.first)
  }

  func testCalculatedPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"],
                      "aa:bb:cc:dd:ee:ff": ["prefixes": "And, THAT here?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let prefixes = configuration.prefixes.calculatedPrefixesForInterface(address)
    XCTAssertEqual(MACPrefix("000393"), prefixes.first)
  }

  func testCalculatedPrefixesForInterfaceWithOnlyDefault() {
    let dictionary = ["default": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let prefixes = configuration.prefixes.calculatedPrefixesForInterface(address)
    XCTAssertEqual(1, prefixes.count)
    XCTAssertEqual(MACPrefix("000000"), prefixes.first)
  }

  func testCalculatedPrefixesForInterfaceWithOnlyInterface() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("00:00:00")], configuration.prefixes.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithBothDefaultAndInterface() {
    let dictionary = [
      "default": ["prefixes": "11:11:11"],
      "aa:bb:cc:dd:ee:ff": ["prefixes": "22:22:22"]
    ]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("22:22:22")], configuration.prefixes.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithBothDefaultAndInterfaceAndCustom() {
    let dictionary = [
      "default": ["vendors": "ibm", "prefixes": "11:11:11"],
      "aa:bb:cc:dd:ee:ff": ["vendors":"3com", "prefixes": "22:22:22"]
    ]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    let prefixes = configuration.prefixes.calculatedPrefixesForInterface(address)
    XCTAssertEqual(4, prefixes.count) // 1 Custom + All 3Com
    XCTAssertEqual(MACPrefix("22:22:22"), prefixes[0])
    XCTAssertEqual(MACPrefix("00:60:08"), prefixes[1])
  }

}
