// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

@main

struct LinkLiarApp: App {
  @State private var state = LinkState()

  // MARK: Class Methods

  init() {
    // Start observing the config file.
    configFileObserver = FileObserver(path: Paths.configFile, callback: configFileChanged)

    // Start observing changes of ethernet interfaces
    networkObserver = NetworkObserver(callback: networkConditionsChanged)

    // Start observing when the user opens the menu bar by clicking on it.
    NotificationCenter.default.addObserver(
      forName: .menuBarAppeared, object: nil, queue: nil, using: menuBarAppeared
    )

    NotificationCenter.default.addObserver(
      forName: .manualTrigger, object: nil, queue: nil, using: manualTrigger
    )

    // Load config file once.
    configFileChanged()

    MACVendors.load()
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
      state.configDictionary = JSONReader(Paths.configFile).dictionary
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

  private func manualTrigger(_ _: Notification) {
    DispatchQueue.main.async {
      Log.debug("Manual reload requested")
      Controller.queryAllSoftMACs(state)
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
