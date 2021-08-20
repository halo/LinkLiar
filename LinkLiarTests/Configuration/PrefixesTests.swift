
import XCTest
@testable import LinkLiar

class ConfigurationPrefixesTests: XCTestCase {

  // #prefixesForDefaultInterface

  func testPrefixesForDefaultWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertTrue(configuration.prefixes.prefixesForDefaultInterface.isEmpty)
  }

  func testPrefixesForDefaultWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertTrue(configuration.prefixes.prefixesForDefaultInterface.isEmpty)
  }

  func testPrefixesForDefaultWithAtLeastOneValidPrefix() {
    let dictionary = ["default": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixes.prefixesForDefaultInterface)
  }

  func testPrefixesForDefaultWithWhitespace() {
    let dictionary = ["default": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixes.prefixesForDefaultInterface)
  }

  // #prefixesForInterface

  func testPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.prefixesForInterface(address).isEmpty)
  }

  func testPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "WHAT,is, this?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.prefixesForInterface(address).isEmpty)
  }

  func testPrefixesForInterfaceWithAtLeastOneValidPrefix() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "aa:bb:cc:dd:ee:ff,55:55:5,88:88:88,99:99:99"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("888888"),
      MACPrefix("999999")
    ], configuration.prefixes.prefixesForInterface(address))
  }

  func testPrefixesForInterfaceWithWhitespace() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "  aA:bB: CC , DD:e e:ff "]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([
      MACPrefix("aa:bb:cc"),
      MACPrefix("dd:ee:ff")
    ], configuration.prefixes.prefixesForInterface(address))
  }

  // #calculatedPrefixesForInterface (directly)

  func testCalculatedPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.calculatedPrefixesForInterface(address).isEmpty)
  }

  func testCalculatedPrefixesForInterfaceWhenInvalid() {
    let dictionary = ["default": ["prefixes": "WHAT,is, this?"],
                      "aa:bb:cc:dd:ee:ff": ["prefixes": "And, THAT here?"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertTrue(configuration.prefixes.calculatedPrefixesForInterface(address).isEmpty)
  }

  func testCalculatedPrefixesForInterfaceWithOnlyDefault() {
    let dictionary = ["default": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("00:00:00")], configuration.prefixes.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithOnlyInterface() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["prefixes": "000000"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("00:00:00")], configuration.prefixes.calculatedPrefixesForInterface(address))
  }

  func testCalculatedPrefixesForInterfaceWithBothDefaultAndInterface() {
    let dictionary = [
      "default": ["prefixes": "11:11:11"],
      "aa:bb:cc:dd:ee:ff": ["prefixes": "22:22:22"]
    ]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual([MACPrefix("22:22:22")], configuration.prefixes.calculatedPrefixesForInterface(address))
  }
}
