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
      
      VStack {
        Button(action: Controller.doAuthorize) {
          Text("Authorize...")
        }
      }.tabItem {
        Image(systemName: "checkmark.circle")
        Text("General")
      }
      
      VStack {
        Text("This is where the config file is located:")
        Text(Paths.configFile)
        Button(action: ConfigWriter.reset) {
          Text("Reset Config file")
        }
        Text("Writable: \(ConfigWriter.isWritable ? "Yes" : "No")")
      }.tabItem {
        Image(systemName: "sun.min")
        Text("Config file")
      }
      
      
    }.frame(width: 500, height: 300)
    
  }
}

//#Preview {
//  SettingsView()
//}
