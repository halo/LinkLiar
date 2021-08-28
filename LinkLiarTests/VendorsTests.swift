
import XCTest
@testable import LinkLiar

class VendorsTests: XCTestCase {

  func testFindWhenMissing() throws {
    let vendor = Vendors.find("no-the-vendor-youre-looking-for")
    XCTAssertNil(vendor)
  }

  func testFindWhenExists() throws {
    let vendor = try XCTUnwrap(Vendors.find("ibm"))
    XCTAssertEqual("ibm", vendor.id)
    XCTAssertEqual("IBM", vendor.name)
    XCTAssertEqual(MACPrefix("3440b5"), vendor.prefixes.first)
  }

}
