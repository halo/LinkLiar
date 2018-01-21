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

class JSONReaderTests: XCTestCase {

  func fixturePath(_ name: String) -> String {
    let bundle = Bundle(for: type(of: self))
    let filename = name.components(separatedBy: ".")
    return bundle .url(forResource: filename.first, withExtension: filename.last)!.path
  }

  func testContentWhenFileDoesNotExist() {
    let reader = JSONReader(filePath: "/dev/null/non-existent.json")
    XCTAssertNil(reader.data)
  }

  func testContentWithNonJson() {
    let reader = JSONReader(filePath: fixturePath("justText.json"))
    let content = String(data: reader.data!, encoding: String.Encoding.utf8)
    XCTAssertEqual("I am not JSON.\n", content!)
  }

  func testObjectWithSimpleJson() {
    let reader = JSONReader(filePath: fixturePath("minimalConfig.json"))
    let json = reader.dictionary
    XCTAssertEqual(json.count, 1)
    XCTAssertEqual(json["version"] as? String, "0.0.1")
  }

  func testObjectWithNonJson() {
    let reader = JSONReader(filePath: fixturePath("justText.json"))
    let json = reader.dictionary
    XCTAssertEqual(json.count, 0)
  }

}
