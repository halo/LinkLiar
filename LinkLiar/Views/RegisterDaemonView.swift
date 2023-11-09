import SwiftUI

struct RegisterDaemonView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    if state.daemonRegistration == .notRegistered {
      VStack {
        VStack {
          
          Text("The LinkLiar background service is not installed yet. Please install it first.").frame(maxWidth: 200)
          
          Button(action: { Controller.registerDaemon(state: state) }) {
            Text("Install")
          }
        }.padding()
        Divider()
      }.frame(alignment: .topLeading)
    }
  }
}
