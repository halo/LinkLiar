/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import XCTest
@testable import LinkLiar

class PathTests: XCTestCase {

  func testConfigDirectory() {
    let path = Paths.configDirectory
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar", path)
  }

  func testConfigDirectoryURL() {
    let url = Paths.configDirectoryURL
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar", url.path)
  }

  func testConfigFile() {
    let path = Paths.configFile
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar/config.json", path)
  }

  func testConfigFileURL() {
    let url = Paths.configFileURL
    XCTAssertEqual("/Library/Application Support/io.github.halo.LinkLiar/config.json", url.path)
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
    let path = Paths.daemonPristineExecutablePath
    XCTAssertTrue(path.hasSuffix("/LinkLiar.app/Contents/Resources/linkdaemon"))
  }

  func testDaemonPristineExecutableURL() {
    let url = Paths.daemonPristineExecutableURL
    XCTAssertTrue(url.path.hasSuffix("/LinkLiar.app/Contents/Resources/linkdaemon"))
  }

  func testDaemonDirectory() {
    let path = Paths.daemonDirectory
    XCTAssertEqual("/Library/Application Support/io.github.halo.linkdaemon", path)
  }

  func testDaemonDirectoryURL() {
    let url = Paths.daemonDirectoryURL
    XCTAssertEqual("/Library/Application Support/io.github.halo.linkdaemon", url.path)
  }

  func testDaemonExecutable() {
    let path = Paths.daemonExecutable
    XCTAssertEqual("/Library/Application Support/io.github.halo.linkdaemon/linkdaemon", path)
  }

  func testDaemonExecutableURL() {
    let url = Paths.daemonExecutableURL
    XCTAssertEqual("/Library/Application Support/io.github.halo.linkdaemon/linkdaemon", url.path)
  }

}
