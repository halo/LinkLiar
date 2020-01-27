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

class MACPrefixTests: XCTestCase {

  func testFormattedWithAlreadyFormattedPrefix() {
    let prefix = MACPrefix("aa:bb:cc")
    XCTAssertEqual("aa:bb:cc", prefix.formatted)
  }

  func testFormattedWithUpcasedPrefix() {
    let prefix = MACPrefix("AA:bB:44")
    XCTAssertEqual("aa:bb:44", prefix.formatted)
  }

  func testFormattedWithWhitespacePrefix() {
    let prefix = MACPrefix("  AA : bB:4 4  ")
    XCTAssertEqual("aa:bb:44", prefix.formatted)
  }

  func testFormattedWithoutColons() {
    let prefix = MACPrefix("aabb00")
    XCTAssertEqual("aa:bb:00", prefix.formatted)
  }

  func testFormattedWithInvalidPrefix() {
    let prefix = MACPrefix("aabb00XX")
    XCTAssertEqual("aa:bb:00", prefix.formatted)
  }

  func testhumanReadableWithInvalidPrefix() {
    let prefix = MACPrefix("aabbXX")
    XCTAssertEqual("??:??:??", prefix.humanReadable)
  }

  func testIsValidWithValidPrefix() {
    let prefix = MACPrefix("aabb00")
    XCTAssertTrue(prefix.isValid)
  }

  func testIsValidWithInvalidPrefix() {
    let prefix = MACPrefix("aabb0")
    XCTAssertFalse(prefix.isValid)
  }

  func testEquatableWithTwoEqualAddresses() {
    let prefix1 = MACPrefix("aa:Bb: cc")
    let prefix2 = MACPrefix(" A A :bb:cc")
    XCTAssertTrue(prefix1 == prefix2)
  }

  func testEquatableWithTwoDifferentAddresses() {
    let prefix1 = MACPrefix("aa:aa:aa")
    let prefix2 = MACPrefix("bb:bb:bb")
    XCTAssertFalse(prefix1 == prefix2)
  }

}
