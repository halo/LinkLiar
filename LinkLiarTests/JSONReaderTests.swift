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
