/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

class ConfigurationTests: XCTestCase {

  func testDictionary() {
    let dictionary = ["one": 1]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual(["one": 1], configuration.dictionary as! [String: Int])
  }

  func testRestrictDaemonWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertFalse(configuration.isRestrictedDaemon)
  }

  func testRestrictDaemonWhenTrue() {
    let dictionary = ["restrict_daemon": true]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.isRestrictedDaemon)
  }

  func testRestrictDaemonWhenTruthyString() {
    let dictionary = ["restrict_daemon": "true"]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertFalse(configuration.isRestrictedDaemon)
  }

  func testRestrictDaemonWhenFalse() {
    let dictionary = ["restrict_daemon": false]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertFalse(configuration.isRestrictedDaemon)
  }

  func testIsForbiddenToRerandomizeWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertFalse(configuration.isForbiddenToRerandomize)
  }

  func testIsForbiddenToRerandomizeWhenTrue() {
    let dictionary = ["skip_rerandom": true]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.isForbiddenToRerandomize)
  }

  func testIsForbiddenToRerandomizeWhenTruthyString() {
    let dictionary = ["skip_rerandom": "true"]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertFalse(configuration.isForbiddenToRerandomize)
  }

  func testIsForbiddenToRerandomizeWhenFalse() {
    let dictionary = ["skip_rerandom": false]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertFalse(configuration.isForbiddenToRerandomize)
  }

  func testCalculatedActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "random"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.random, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidlyType() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["action": "specify"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.specify, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedUsePrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(false, configuration.calculatedUsePrefixesForInterface(address))
  }

  func testCalculatedUsePrefixesForInterfaceWhenDirectlySpecifiedAsTrue() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["user_prefixes": true]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(true, configuration.calculatedUsePrefixesForInterface(address))
  }


  func testExceptionAddressForInterfaceWhenNotSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["except": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["except": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.exceptionAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.calculatedAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.calculatedAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.prefixesForInterface(address))
  }

  func testPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.prefixesForInterface(address))
  }

  func testPrefixesForInterfaceWithAtLeastOneValidPrefix() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixesForInterface(address))
  }

  func testPrefixesForInterfaceWithWhitespace() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixesForInterface(address))
  }

  func testPrefixesForDefaultInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertNil(configuration.prefixesForDefaultInterface())
  }

  func testPrefixesForDefaultInterfaceWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertNil(configuration.prefixesForDefaultInterface())
  }

  func testPrefixesForDefaultInterfaceWithAtLeastOneValidPrefix() {
    let dictionary = ["default": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixesForDefaultInterface())
  }

  func testPrefixesForDefaultInterfaceWithWhitespace() {
    let dictionary = ["default": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixesForDefaultInterface())
  }

  func testCalculatedPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"],
                      "aa:bb:cc:dd:ee:ff": ["prefixes": "And, THAT here?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithOnlyDefault() {
    let dictionary = ["default": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("00:00:00")], configuration.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithOnlyInterface() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("00:00:00")], configuration.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithBothDefaultAndInterface() {
    let dictionary = ["default": ["prefixes": "11:11:11"],
                      "aa:bb:cc:dd:ee:ff": ["prefixes": "22:22:22"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("22:22:22")], configuration.calculatedPrefixesForInterface(address))
  }
}
