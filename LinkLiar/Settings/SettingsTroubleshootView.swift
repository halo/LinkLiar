import SwiftUI
import ServiceManagement

struct SettingsTroubleshootView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    VStack {
      Text("GUI Version: \(Controller.version)")

      Text("Daemon State: \(state.daemonRegistration.rawValue)")
      Text("Daemon Version: \(state.daemonVersion.formatted)")
      HStack {
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
      
      Text("XPC State: \(state.xpcStatus.rawValue)")
      HStack {
        Button(action: { Controller.troubleshoot(state: state) }) {
          Image(systemName: "arrow.2.circlepath")
        }
      }
      
    }.tabItem {
      Image(systemName: "bandage")
      Text("Troubleshoot")
    }
  }
}
