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

  // #vendors

  func testVendorsForDefaultWhenNothingSpecified() throws {
    let configuration = Configuration(dictionary: [:])
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenInvalid() {
    let dictionary = ["vendors": "WHAT,is, this?"]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenVendorsAndPrefixesEmpty() {
    let dictionary = ["vendors": "", "prefixes": ""]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWhenPrefixesExist() {
    let dictionary = ["vendors": "", "prefixes": "aa:bb:cc"]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(MACPrefix("000393"), vendors.first!.prefixes.first)
  }

  func testVendorsForDefaultWithAtLeastOneValidVendor() throws {
    let dictionary = ["vendors": ["ibm", "fruit-tree", "3com"]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(2, vendors.count)
    let threecom = try XCTUnwrap(vendors[0])
    let ibm = try XCTUnwrap(vendors[1])
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3com", threecom.name)
    XCTAssertEqual(MACPrefix("000102"),threecom.prefixes.first)
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("Ibm", ibm.name)
    XCTAssertEqual(MACPrefix("000255"), ibm.prefixes.first)
  }

  func testVendorsForDefaultWithWhitespace() throws {
    let dictionary = ["vendors": ["  ibm  ", "fruit-tree", "3com "]]
    let configuration = Configuration(dictionary: dictionary)
    let vendors = configuration.prefixes.vendors
    XCTAssertEqual(2, vendors.count)
    let threecom = try XCTUnwrap(vendors[0])
    let ibm = try XCTUnwrap(vendors[1])
    XCTAssertEqual("3com", threecom.id)
    XCTAssertEqual("3com", threecom.name)
    XCTAssertEqual(MACPrefix("000102"),threecom.prefixes.first)
    XCTAssertEqual("ibm", ibm.id)
    XCTAssertEqual("Ibm", ibm.name)
    XCTAssertEqual(MACPrefix("000255"), ibm.prefixes.first)
  }

  // #prefixes

  func testPrefixesForDefaultWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertTrue(configuration.prefixes.prefixes.isEmpty)
  }

  func testPrefixesForDefaultWhenInvalid() {
    let dictionary = ["prefixes": ["WHAT", "is", " this?"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.prefixes.prefixes.isEmpty)
  }

  func testPrefixesForDefaultWithAtLeastOneValidPrefix() {
    let dictionary = ["prefixes": ["aa:bb:cc:dd:ee:ff", " 88:88:88 ", "55:55:5", "99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixes.prefixes)
  }

  func testPrefixesForDefaultWithWhitespace() {
    let dictionary = ["prefixes": ["  aA:bB: CC ", " DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixes.prefixes)
  }

  // #calculatedPrefixes

  func testcalculatedPrefixesWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let prefixes = configuration.prefixes.calculatedPrefixes
    XCTAssertEqual(MACPrefix("000393"), prefixes.first)
  }

  func testcalculatedPrefixesWhenInvalid() {
    let dictionary = ["prefixes": ["WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let prefixes = configuration.prefixes.calculatedPrefixes
    XCTAssertEqual(MACPrefix("000393"), prefixes.first)
  }

  func testcalculatedPrefixesWithOnlyDefault() {
    let dictionary = ["prefixes": ["000000"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("00:00:00"),
    ], configuration.prefixes.prefixes)
  }

}
