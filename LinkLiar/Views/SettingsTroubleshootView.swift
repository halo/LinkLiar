import SwiftUI
import ServiceManagement

struct SettingsTroubleshootView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    VStack {
      HStack {
        Text("Daemon State: \(state.daemonRegistration.rawValue)")
        
        Button(action: { Controller.registerDaemon(state: state) }) {
          Text("Register Daemon")
        }
        Button(action: SMAppService.openSystemSettingsLoginItems) {
          Text("Show Login Items")
        }
        Button(action: { Controller.unregisterDaemon(state: state) }) {
          Text("Unregister Daemon")
        }
      }
      HStack {
        
        Text("XPC State: \(state.xpcStatus.rawValue)")
        //      Text("Daemon connected: \(state.connectedToDaemon.description)")
        
        Button(action: { Controller.troubleshoot(state: state) }) {
          Image(systemName: "arrow.2.circlepath")
        }
        
      }.tabItem {
        Image(systemName: "bandage")
        Text("Troubleshoot")
      }
      
      
    }
  }
}
