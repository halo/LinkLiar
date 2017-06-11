import XCTest
@testable import LinkLiar

class MACAddressTests: XCTestCase {

  func testFormattedWithAlreadyFormattedMAC() {
    let mac = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", mac.formatted())
  }

  func testFormattedWithUpcasedMAC() {
    let mac = MACAddress("AA:bB:44:DD:ee:FF")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted())
  }

  func testFormattedWithWhitespaceMAC() {
    let mac = MACAddress("  AA : bB:4 4:  DD:ee:FF  ")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted())
  }

  func testFormattedWithoutColons() {
    let mac = MACAddress("aabb00ddee88")
    XCTAssertEqual("aa:bb:00:dd:ee:88", mac.formatted())
  }

}
