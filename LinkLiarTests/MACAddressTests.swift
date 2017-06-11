import XCTest
@testable import LinkLiar

class MACAddressTests: XCTestCase {

  func testFormattedWithAlreadyFormattedMAC() {
    let mac = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithUpcasedMAC() {
    let mac = MACAddress("AA:bB:44:DD:ee:FF")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithWhitespaceMAC() {
    let mac = MACAddress("  AA : bB:4 4:  DD:ee:FF  ")
    XCTAssertEqual("aa:bb:44:dd:ee:ff", mac.formatted)
  }

  func testFormattedWithoutColons() {
    let mac = MACAddress("aabb00ddee88")
    XCTAssertEqual("aa:bb:00:dd:ee:88", mac.formatted)
  }

  func testFormattedWithInvalidMAC() {
    let mac = MACAddress("aabb00ddeeXX")
    XCTAssertEqual("aa:bb:00:dd:ee", mac.formatted)
  }

  func testhumanReadableWithInvalidMAC() {
    let mac = MACAddress("aabb00ddeeXX")
    XCTAssertEqual("??:??:??:??:??:??", mac.humanReadable)
  }

  func testIsValidWithValidMac() {
    let mac = MACAddress("aabb00ddee8")
    XCTAssertFalse(mac.isValid)
  }

  func testIsValidWithInvalidMac() {
    let mac = MACAddress("aabb00ddee88")
    XCTAssertTrue(mac.isValid)
  }

  func testEquatableWithTwoEqualAddresses() {
    let mac1 = MACAddress("aa:Bb:cc:88:ee :ff")
    let mac2 = MACAddress(" A A :bb:cc:88:ee:FF")
    XCTAssertTrue(mac1 == mac2)
  }

  func testEquatableWithTwoDifferentAddresses() {
    let mac1 = MACAddress("aa:aa:aa:aa:aa:aa")
    let mac2 = MACAddress("bb:bb:bb:bb:bb:bb")
    XCTAssertFalse(mac1 == mac2)
  }

}
