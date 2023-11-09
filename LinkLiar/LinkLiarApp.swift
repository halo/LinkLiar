import SwiftUI

@main

struct LinkLiarApp: App {
  @State private var state = LinkState()
  
  init() {
    Controller.troubleshoot(state: state)

    NotificationCenter.default.addObserver(forName: .menuBarAppeared, object: nil, queue: nil, using: menuBarAppeared)

    // Start observing Network condition changes.
    NotificationCenter.default.addObserver(forName: .networkConditionsChanged, object: nil, queue: nil, using: networkConditionsChanged)
    NetworkObserver.observe()
  }
  
  // We have no way to detect whether someone changed a MAC address using ifconfig in the Terminal.
  // Therefore we need to re-query all malleable MAC addresses evey time the menu bar is clicked on.
  private func menuBarAppeared(_ _: Notification) {
    Log.debug("Menu Bar appeared")
    Controller.queryAllSoftMACs(state: state)
  }

  private func networkConditionsChanged(_ _: Notification) {
    Log.debug("Network change detected, acting upon it")
    Controller.queryInterfaces(state: state)
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
