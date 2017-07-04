import XCTest
@testable import LinkLiar

class AppDelegateTests: XCTestCase {

  func testVersion() {
    let version = AppDelegate.version
    XCTAssertEqual("2.0.0", version.formatted)
  }

}
