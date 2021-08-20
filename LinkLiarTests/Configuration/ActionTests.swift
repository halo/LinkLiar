import XCTest
@testable import LinkLiar

class ConfigurationActionTests: XCTestCase {

  // #calculatedForDefaultInterface

  func testActionForDefaultWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    XCTAssertEqual(.ignore, configuration.action.calculatedForDefaultInterface)
  }

  // #forInterface

  func testActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.action.forInterface(address))
  }

  // #calculatedForInterface (directly)

  func testCalculatedActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidlyType() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "random"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.random, configuration.action.calculatedForInterface(address))
  }

  // #calculatedForInterface (via default)

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidlyType() {
    let dictionary = ["default": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.action.calculatedForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["action": "specify"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.specify, configuration.action.calculatedForInterface(address))
  }
}
