import SwiftUI

struct SettingsInterfaceView: View {
  @Environment(LinkState.self) private var state
//  @State var selectedInterfaceId: Interface.ID?

  var body: some View {
    let interface = state.settingsEditingInterface
    
    VStack {
      HStack {
        Text(interface?.displayName ?? "?")
        Text(interface?.BSDName ?? "?")
      }
      
      GroupBox {
        Text("Random")
      }.background(.red)
      
      GroupBox {
        Text("Ignore")
      }
      
      GroupBox {
        Text("Hide")
      }
    }
    
  }
  
//  private va"r interface: Interface {
//    state.settingsEditingInterface!
//  }"
}

#Preview {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  return SettingsInterfaceView().environment(state)
}
