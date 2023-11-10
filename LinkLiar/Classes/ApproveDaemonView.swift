import SwiftUI
import ServiceManagement

struct ApproveDaemonView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    if state.daemonRegistration == .requiresApproval {
      VStack {
        
        Image(systemName: "lock.shield")
          .font(.system(size: 40))
          .padding(.bottom, 4)
        
        Text("The LinkLiar background service\nwas installed and is waiting for\napproval.")
          .padding(.bottom, 4)
        
        Text("Please head over to the System\nSettings and activate it in the list\nof background services.")
          .padding(.bottom, 4)
        
        Button(action: SMAppService.openSystemSettingsLoginItems) {
          Text("Show Settings")
        }.padding(.bottom, 4)
          .buttonStyle(.borderedProminent)
      }
      
      Divider().padding(.vertical, 5)
    }
  }
}

#Preview {
  let state = LinkState()
  state.daemonRegistration = .requiresApproval
  return ApproveDaemonView().environment(state)
}
