import SwiftUI

struct LinkMenu: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    Button("One") {
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
