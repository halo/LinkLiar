import SwiftUI

struct SettingsTroubleshootView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    VStack {
      Button(action: { Controller.troubleshoot(state: state) }) {
        Image(systemName: "arrow.2.circlepath")
      }
      Text("XPC: \(state.xpcStatus)")
      Text("Daemon connected: \(state.connectedToDaemon.description)")
      
      
    }.tabItem {
      Image(systemName: "bandage")
      Text("Troubleshoot")
    }
    
    
  }
}
