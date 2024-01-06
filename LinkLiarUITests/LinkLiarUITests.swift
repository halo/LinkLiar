// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest

final class LinkLiarUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
      // Setup
      let configFilePath = "/tmp/LinkLiar.\(Date.now.timeIntervalSince1970).json"

      // Launch
      let app = XCUIApplication()
      app.launchArguments = ["--config", configFilePath]
      app.launch()

      // Test
      app.menuBars.statusItems.firstMatch.click()
      app/*@START_MENU_TOKEN@*/.buttons["Settings"]/*[[".dialogs",".groups.buttons[\"Settings\"]",".buttons[\"Settings\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.click()
      
      let settings = app.windows.firstMatch
      settings.outlines["Sidebar"].buttons["Interface Default"].click()
      settings.popUpButtons["Ignore"].click()
      settings.menuItems["Always Keep Random"].click()

      let expected: [String: Any] = [
        "default" :     [
          "action": "random",
        ],
        "version": "4.0.0"
      ]

      let config = JSONReader(configFilePath).dictionary
      XCTAssertEqual(expected as NSDictionary, config as NSDictionary)
    }

//    func testLaunchPerformance() throws {
//      // This measures how long it takes to launch your application.
//      measure(metrics: [XCTApplicationLaunchMetric()]) {
//          XCUIApplication().launch()
//      }
//    }
}
