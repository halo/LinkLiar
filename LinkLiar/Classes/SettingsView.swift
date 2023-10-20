import SwiftUI

@Observable 

class LinkState {
  var warnAboutLeakage = false
}


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

struct SettingsView: View {
  var body: some View {
    TabView {
      Text("Things...")
        .tabItem {
          Image(systemName: "checkmark.circle")
          Text("Interfaces")
        }
      
      Text("Tab 2 content here")
        .tabItem {
          Image(systemName: "sun.min")
          Text("MAC Prefixes")
        }
    }.frame(width: 200, height: 150)
    
  }
}

//#Preview {
//  SettingsView()
//}
