//

import Foundation
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

class KnownInterfaceTests: XCTestCase {

  func testExceptionAddressForInterfaceWhenSpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["except": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.knownInterface.exceptionAddress(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.calculatedAddress(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.knownInterface.calculatedAddress(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.calculatedAddress(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.calculatedAddress(address))
  }

  func testCalculatedAddressWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.knownInterface.calculatedAddress(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.calculatedAddress(address))
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.calculatedAddress(address))
  }

}