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
