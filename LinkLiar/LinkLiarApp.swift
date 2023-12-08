/*
* Copyright (C) halo https://io.github.com/halo/LinkLiar
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

import SwiftUI

@main

struct LinkLiarApp: App {
  @State private var state = LinkState()

  // MARK: Class Methods

  init() {
    // Start observing the config file.
    configFileObserver = FileObserver.init(path: Paths.configFile, callback: configFileChanged)

    // Load config file once.
    configFileChanged()

    // Start observing changes of ethernet interfaces
    networkObserver = NetworkObserver(callback: networkConditionsChanged)

    // Start observing when the user opens the menu bar by clicking on it.
    NotificationCenter.default.addObserver(
      forName: .menuBarAppeared, object: nil, queue: nil, using: menuBarAppeared
    )
  }

  // MARK: Private Instance Properties

  private var configFileObserver: FileObserver?
  private var networkObserver: NetworkObserver?

  // MARK: Private Instance Methods

  private func configFileChanged() {
    // While the menu is expanded, we must not change it's state on a background thread.
    // All state-changing operations must be run on the main thread.
    DispatchQueue.main.async {
      Log.debug("Config file change detected, acting upon it")
      state.configDictionary = JSONReader.init(filePath: Paths.configFile).dictionary
    }
  }

  // We have no way to detect whether someone changed a MAC address using ifconfig in the Terminal.
  // Therefore we should to re-query all MAC addresses evey time the menu bar is clicked on.
  private func menuBarAppeared(_ _: Notification) {
    DispatchQueue.main.async {
      Log.debug("Menu Bar appeared")
      Controller.queryAllSoftMACs(state)
      Controller.queryDaemonRegistration(state: state)

      // If there was a "do you really want to quit?" warning,
      // we can remove it once the menu bar was closed and reopened.
      Controller.wantsToStay(state)
    }
  }

  private func networkConditionsChanged() {
    DispatchQueue.main.async {
      Log.debug("Network change detected, acting upon it")
      Controller.queryInterfaces(state: state)
    }
  }

  var body: some Scene {
    MenuBarExtra("LinkLiar", image: menuBarIconName) {
      MenuView().environment(state)
    }.menuBarExtraStyle(.window)

    Settings {
      SettingsView().environment(state)
    }.windowStyle(.hiddenTitleBar)
  }

  private var menuBarIconName: String {
    state.warnAboutLeakage ? "MenuIconLeaking" : "MenuIconProtected"
  }

}
