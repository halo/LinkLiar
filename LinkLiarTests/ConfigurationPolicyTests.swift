/*
 * Copyright (C)  halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */


import XCTest
@testable import LinkLiar

class ConfigurationPolicyTests: XCTestCase {
  
  func testAccessPointsInvalidDataType() {
    let dictionary = ["ssids:aa:aa:aa:bb:bb:bb": "bad"] as [String: String]
    let policy = Configuration.Policy("aa:aa:aa:bb:bb:bb", dictionary: dictionary)
    XCTAssertEqual([], policy.accessPoints)
  }
  
  func testAccessPoints() {
    let dictionary = ["ssids:aa:aa:aa:aa:aa:aa":
                        ["Coffeeshop": "bb:bb:bb:bb:bb:bb",
                         "Invalid MAC": "XX:bb:bb:bb:bb:bb",
                         "Empty MAC": "",
                         "": "ff:ff:ff:ff:ff:ff",
                         "Papershop": "cc:cc:cc:cc:cc:cc"],
    ] as [String: [String: String]]
    let policy = Configuration.Policy("aa:aa:aa:aa:aa:aa", dictionary: dictionary)
    let accessPoints = policy.accessPoints
    XCTAssertEqual(2, accessPoints.count)
    
    let accessPoint1 = accessPoints.first!
    XCTAssertEqual("Coffeeshop", accessPoint1.ssid)
    XCTAssertEqual(MACAddress("bb:bb:bb:bb:bb:bb"), accessPoint1.softMAC)
    
    let accessPoint2 = accessPoints.last!
    XCTAssertEqual("Papershop", accessPoint2.ssid)
    XCTAssertEqual(MACAddress("cc:cc:cc:cc:cc:cc"), accessPoint2.softMAC)
  }
  
}
