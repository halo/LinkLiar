/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

class MACAddressTests: XCTestCase {

  func testFormattedWithAlreadyFormattedMAC() {
    let mac = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithUpcasedMAC() {
    let mac = MACAddress("AA:bB:44:DD:ee:FF")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithWhitespaceMAC() {
    let mac = MACAddress("  AA : bB:4 4:  DD:ee:FF  ")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithoutColons() {
    let mac = MACAddress("aabb00ddee88")
    XCTAssertEqual("aa:bb:00:dd:ee:88", mac.formatted)
  }

  func testFormattedWithInvalidMAC() {
    let mac = MACAddress("aabb00ddeeXX")
    XCTAssertEqual("aa:bb:00:dd:ee", mac.formatted)
  }

  func testhumanReadableWithInvalidMAC() {
    let mac = MACAddress("aabb00ddeeXX")
    XCTAssertEqual("??:??:??:??:??:??", mac.humanReadable)
  }

  func testIsValidWithValidMac() {
    let mac = MACAddress("aabb00ddee8")
    XCTAssertFalse(mac.isValid)
  }

  func testIsValidWithInvalidMac() {
    let mac = MACAddress("aabb00ddee88")
    XCTAssertTrue(mac.isValid)
  }

  func testEquatableWithTwoEqualAddresses() {
    let mac1 = MACAddress("aa:Bb:cc:88:ee :ff")
    let mac2 = MACAddress(" A A :bb:cc:88:ee:FF")
    XCTAssertTrue(mac1 == mac2)
  }

  func testAdd() {
    let mac1 = MACAddress("11:aa:11:11:11:ff")
    let mac2 = MACAddress("11:22:33:00:55:66")
    let mac = mac1.add(mac2)
    XCTAssertEqual("22:cc:44:11:66:55", mac.formatted)
  }

  func testEquatableWithTwoDifferentAddresses() {
    let mac1 = MACAddress("aa:aa:aa:aa:aa:aa")
    let mac2 = MACAddress("bb:bb:bb:bb:bb:bb")
    XCTAssertFalse(mac1 == mac2)
  }

}
