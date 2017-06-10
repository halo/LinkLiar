import XCTest
@testable import LinkLiar

class ConfigurationTests: XCTestCase {

  func fixturePath(_ name: String) -> String {
    let bundle = Bundle(for: type(of: self))
    let filename = name.components(separatedBy: ".")
    return bundle .url(forResource: filename.first, withExtension: filename.last)!.path
  }

  func testContentWhenFileDoesNotExist() {
    let reader = ConfigReader(filePath: "/dev/null/non-existent.json")
    XCTAssertNil(reader.data())
  }

  func testContentWithNonJson() {
    let reader = ConfigReader(filePath: fixturePath("justText.json"))
    let content = String(data: reader.data()!, encoding: String.Encoding.utf8)
    XCTAssertEqual("I am not JSON.\n", content!)
  }

}
