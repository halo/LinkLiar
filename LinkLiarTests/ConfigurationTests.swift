
import XCTest
@testable import LinkLiar

class ConfigurationTests: XCTestCase {
  
  func testDictionary() {
    let dictionary = ["one": 1]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual(["one": 1], configuration.dictionary as! [String: Int])
  }
  
}
