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

class InterfaceTests: XCTestCase {

  func testTitle() {
    let interface = Interface(BSDName: "My BSD", displayName: "My display", kind: "My kind", hardMAC: "aa:bb:cc:dd:ee:ff", async: false)

    XCTAssertEqual("My display · My BSD", interface.title)
  }

  func testSoftPrefix() {
    let interface = Interface(BSDName: "x", displayName: "y", kind: "z", hardMAC: "aa:bb:cc:dd:ee:ff", async: false)
    interface._softMAC = "55:55:55:77:88:99"

    XCTAssertEqual(MACPrefix("55:55:55"), interface.softPrefix)
  }

}
