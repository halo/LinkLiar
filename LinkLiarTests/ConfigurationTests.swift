
import XCTest
@testable import LinkLiar

class ConfigurationTests: XCTestCase {
  
  func testDictionaryWithStrings() {
    let dictionary = ["one": "two"]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual(["one": "two"], configuration.dictionary as! [String: String])
  }
  
  func testDictionaryWithIntegers() {
    let dictionary = ["one": 1]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual(["one": 1], configuration.dictionary as! [String: Int])
  }
  
}
