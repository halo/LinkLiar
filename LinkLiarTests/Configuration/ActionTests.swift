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

class ConfigurationActionTests: XCTestCase {

  // #calculatedForDefaultInterface

  func testActionForDefaultWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertEqual(.ignore, configuration.knownInterface.defaultAction)
  }

  // #forInterface

  func testActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.knownInterface.action(address))
  }

  // #calculatedForInterface (directly)

  func testCalculatedActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidlyType() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "random"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.random, configuration.knownInterface.calculatedAction(address))
  }

  // #calculatedForInterface (via default)

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidlyType() {
    let dictionary = ["default": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.knownInterface.calculatedAction(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["action": "specify"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.specify, configuration.knownInterface.calculatedAction(address))
  }
}
