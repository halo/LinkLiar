import XCTest
@testable import LinkLiar

class ConfigurationTests: XCTestCase {

  func testDictionary() {
    let dictionary = ["one": 1]
    let configuration = Configuration(dictionary: dictionary)
    XCTAssertEqual(["one": 1], configuration.dictionary as! [String: Int])
  }

  func testCalculatedActionForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "random"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.random, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenDirectlySpecifiedInvalidlyType() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["action": 42]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["action": "specify"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.specify, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["action": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testCalculatedActionForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual(.ignore, configuration.calculatedActionForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenNotSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["except": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.exceptionAddressForInterface(address))
  }

  func testExceptionAddressForInterfaceWhenSpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["except": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.exceptionAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenNothingSpecified() {
    let configuration = Configuration(dictionary: [:])
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecified() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.calculatedAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedInvalidly() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenDirectlySpecifiedMissing() {
    let dictionary = ["aa:bb:cc:dd:ee:ff": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefault() {
    let dictionary = ["default": ["address": "bb:bb:bb:bb:bb:bb"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertEqual("bb:bb:bb:bb:bb:bb", configuration.calculatedAddressForInterface(address)?.formatted)
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultInvalidly() {
    let dictionary = ["default": ["address": "br:ok:en"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

  func testCalculatedAddressForInterfaceWhenSpecifiedAsDefaultMissing() {
    let dictionary = ["default": ["whatever": "whatever"]]
    let configuration = Configuration(dictionary: dictionary)
    let address = MACAddress("aa:bb:cc:dd:ee:ff")
    XCTAssertNil(configuration.calculatedAddressForInterface(address))
  }

}
