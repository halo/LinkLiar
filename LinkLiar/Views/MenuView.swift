import SwiftUI

struct MenuView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    ForEach(state.interfaces) { interface in
      VStack {
        Text(interface.displayName)
        Text(interface.BSDName)
        Text(interface.softMAC.humanReadable)
        Text(interface.hardMAC.humanReadable)
      }
    }
    
    
    Text("Welcome to LinkLiar.")
    Text("If you're new to this app, I recommend the beginners guide")

    Button("One One One One One One One One One One One One One \nTwo One One One One One One One One One One One One One One One One One One ") {
      state.warnAboutLeakage = true
    }
    Button("Two") {
      state.warnAboutLeakage = false
    }
    Divider()
    
    SettingsLink{
      Text("Settings...")
    }.keyboardShortcut(",", modifiers: .command)
    Divider()
    
    
    Button("Quit") {
      
      NSApplication.shared.terminate(nil)
      
    }.keyboardShortcut("q")
  }
}

//#Preview {
//  SettingsView()
//}
