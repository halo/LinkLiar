
import XCTest
@testable import LinkLiar

class ConfigurationPrefixesTests: XCTestCase {


  func testPrefixesForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.action.forInterface(address))
  }

}
