import SwiftUI

@main

struct LinkLiarApp: App {
  @State private var state = LinkState()
  
  init() {
    Controller.troubleshoot(state: state)
    NotificationCenter.default.addObserver(forName: .interfacesChanged, object: nil, queue: nil, using: networkConditionsChanged)

    NetworkObserver.observe()
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
      SettingsView().navigationTitle("Settings").environment(state)
    }
  }
  
  private var menuBarIconName: String {
    state.warnAboutLeakage ? "MenuIconLeaking" : "MenuIconProtected"
  }
}
