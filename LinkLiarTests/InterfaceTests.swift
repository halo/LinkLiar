import XCTest
@testable import LinkLiar

class InterfaceTests: XCTestCase {

  func testTitle() {
    let interface = Interface(BSDName: "My BSD", displayName: "My display", hardMAC: "aa:bb:cc:dd:ee:ff", kind: "My kind")

    XCTAssertEqual("My display ∙ My BSD", interface.title)
  }
}
