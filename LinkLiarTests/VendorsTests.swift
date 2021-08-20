
import XCTest
@testable import LinkLiar

class VendorsTests: XCTestCase {

  // #prefixesForDefaultInterface

  func testFind() throws {
    let vendor = try XCTUnwrap(Vendors.find("ibm"))
    XCTAssertEqual("ibm", vendor.name)
    XCTAssertEqual(MACPrefix("3440b5"), vendor.prefixes.first)
  }

}
