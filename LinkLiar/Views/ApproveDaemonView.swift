import SwiftUI
import ServiceManagement

struct ApproveDaemonView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    if state.daemonRegistration == .requiresApproval {
      VStack {
        VStack {
          
          Text("The LinkLiar background service is not authorized yet.").frame(maxWidth: 200)
          Spacer()
          Text("Please head over to the System Settings and activate it in the list of background services.").frame(maxWidth: 200)

          Button(action: SMAppService.openSystemSettingsLoginItems) {
            Text("Show Settings")
          }
        }.padding()
        Divider()
      }.frame(alignment: .topLeading)
    }
  }
}
