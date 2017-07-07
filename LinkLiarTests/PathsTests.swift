import XCTest
@testable import LinkLiar

class PathTests: XCTestCase {

  func testConfigDirectory() {
    let path = Paths.configDirectory
    XCTAssertEqual("/Library/Application Support/LinkLiar", path)
  }

  func testConfigDirectoryURL() {
    let url = Paths.configDirectoryURL
    XCTAssertEqual("/Library/Application Support/LinkLiar", url.path)
  }

  func testConfigFile() {
    let path = Paths.configFile
    XCTAssertEqual("/Library/Application Support/LinkLiar/config.json", path)
  }

  func testConfigFileURL() {
    let url = Paths.configFileURL
    XCTAssertEqual("/Library/Application Support/LinkLiar/config.json", url.path)
  }

  func testHelperDirectory() {
    let path = Paths.helperDirectory
    XCTAssertEqual("/Library/PrivilegedHelperTools", path)
  }

  func testHelperDirectoryURL() {
    let url = Paths.helperDirectoryURL
    XCTAssertEqual("/Library/PrivilegedHelperTools", url.path)
  }

  func testHelperExecutable() {
    let path = Paths.helperExecutable
    XCTAssertEqual("/Library/PrivilegedHelperTools/io.github.halo.linkhelper", path)
  }

  func testHelperExecutableURL() {
    let url = Paths.helperExecutableURL
    XCTAssertEqual("/Library/PrivilegedHelperTools/io.github.halo.linkhelper", url.path)
  }

  func testDaemonsPlistDirectory() {
    let path = Paths.daemonsPlistDirectory
    XCTAssertEqual("/Library/LaunchDaemons", path)
  }

  func testDaemonsPlistDirectoryURL() {
    let url = Paths.daemonsPlistDirectoryURL
    XCTAssertEqual("/Library/LaunchDaemons", url.path)
  }

  func testDaemonPlistFile() {
    let path = Paths.daemonPlistFile
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.linkdaemon.plist", path)
  }

  func testDaemonPlistFileURL() {
    let url = Paths.daemonPlistFileURL
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.linkdaemon.plist", url.path)
  }

  func testHelperPlistFile() {
    let path = Paths.helperPlistFile
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.linkhelper.plist", path)
  }

  func testHelperPlistFileURL() {
    let url = Paths.helperPlistFileURL
    XCTAssertEqual("/Library/LaunchDaemons/io.github.halo.linkhelper.plist", url.path)
  }

  func testDaemonPristineExecutable() {
    let path = Paths.daemonPristineExecutable
    XCTAssertTrue(path.hasSuffix("/LinkLiar.app/Contents/Resources/linkdaemon"))
  }

  func testDaemonPristineExecutableURL() {
    let url = Paths.daemonPristineExecutableURL
    XCTAssertTrue(url.path.hasSuffix("/LinkLiar.app/Contents/Resources/linkdaemon"))
  }

  func testDaemonDirectory() {
    let path = Paths.daemonDirectory
    XCTAssertEqual("/Library/Application Support/LinkDaemon", path)
  }

  func testDaemonDirectoryURL() {
    let url = Paths.daemonDirectoryURL
    XCTAssertEqual("/Library/Application Support/LinkDaemon", url.path)
  }

  func testDaemonExecutable() {
    let path = Paths.daemonExecutable
    XCTAssertEqual("/Library/Application Support/LinkDaemon/linkdaemon", path)
  }

  func testDaemonExecutableURL() {
    let url = Paths.daemonExecutableURL
    XCTAssertEqual("/Library/Application Support/LinkDaemon/linkdaemon", url.path)
  }

}
