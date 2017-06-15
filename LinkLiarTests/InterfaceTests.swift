import XCTest
@testable import LinkLiar

class InterfaceTests: XCTestCase {

  func testTitle() {
    let interface = Interface(BSDName: "My BSD", displayName: "My display", kind: "My kind", hardMAC: "aa:bb:cc:dd:ee:ff", async: false)

    XCTAssertEqual("My display · My BSD", interface.title)
  }
}
