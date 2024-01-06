// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest

final class LinkLiarUITestsLaunchTests: XCTestCase {
  
  override class var runsForEachTargetApplicationUIConfiguration: Bool {
    true
  }
  
  override func setUpWithError() throws {
    continueAfterFailure = false
  }
  
  func testLaunch() throws {
    // Setup
    let configFilePath = "/tmp/LinkLiar.\(Date.now.timeIntervalSince1970).json"

    // Launch
    let app = XCUIApplication()
    app.launchArguments = ["--config", configFilePath]
    app.launch()

    // Test
    app.menuBars.statusItems.firstMatch.click()

    let attachment = XCTAttachment(screenshot: app.screenshot())
    attachment.name = "Launch Screen"
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
