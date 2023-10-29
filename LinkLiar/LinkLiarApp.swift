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
  
  private func networkConditionsChanged(_ _: Notification) {
    Log.debug("Network change detected, acting upon it")
    Controller.queryInterfaces(state: state)
  }  
  
  private func menuBarAppeared(_ _: Notification) {
    Log.debug("MenuBar appeared")
    Controller.troubleshoot(state: state)
  }
  
  var body: some Scene {
    MenuBarExtra("LinkLiar", image: menuBarIconName) {
      MenuView().environment(state)
    }.menuBarExtraStyle(.window)
    
    Settings {
      SettingsView().navigationTitle("Settings").environment(state)
    }
  }
  
  private var menuBarIconName: String {
    state.warnAboutLeakage ? "MenuIconLeaking" : "MenuIconProtected"
  }
  
}
