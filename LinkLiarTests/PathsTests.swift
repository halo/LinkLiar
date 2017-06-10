import XCTest
@testable import LinkLiar

class PathTests: XCTestCase {

  func testConfigDirectory() {
    let path = Paths.configDirectory
    XCTAssertEqual("/Library/Application Support/LinkLiar", path)
  }

  func testConfigDirectoryURL() {
    let url = Paths.configDirectoryURL
    XCTAssertEqual("/Library/Application Support/LinkLiar", url.path)
  }

  func testConfigFile() {
    let path = Paths.configFile
    XCTAssertEqual("/Library/Application Support/LinkLiar/config.json", path)
  }

}
