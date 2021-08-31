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

class JSONWriterTests: XCTestCase {

  func tempPath(_ fileName: String) -> String {
    let directory = NSTemporaryDirectory()
    return URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent(fileName).path
  }

  func testWriteWithEmptyDictionary() {
    let path = tempPath("empty.json")
    let dictionary = [String: Any]()
    JSONWriter(filePath: path).write(dictionary)
    let json = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    XCTAssertEqual("{\n\n}", json)
  }

  func testWriteWithVersion() {
    let path = tempPath("empty.json")
    let dictionary = ["version": "42"]
    JSONWriter(filePath: path).write(dictionary)
    let json = try! String(contentsOfFile: path, encoding: String.Encoding.utf8)
    XCTAssertEqual("{\n  \"version\" : \"42\"\n}", json)
  }

}
