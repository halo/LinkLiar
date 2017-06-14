import XCTest
@testable import LinkLiar

class IfconfigTests: XCTestCase {

  func testInitSetsTheBSDName() {
    let ifconfig = Ifconfig(BSDName: "en0")
    XCTAssertEqual("en0", ifconfig.BSDName)
  }


}
