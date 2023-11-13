import SwiftUI

struct SettingsInterfaceActionManageView: View {
  @Environment(LinkState.self) private var state
  
  @State var interface: Interface
  
  var body: some View {
    
    let toggleBinding = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action() == .hide },
      set: { value,_ in ConfigWriter.setInterfaceActionToHidden(interface: interface, isOn: value, state: state) } )
    
    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Show in Menu Bar")
          Text("When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, ").font(.caption)
        }
        Spacer()
        Toggle(isOn: toggleBinding) {}.toggleStyle(.switch).controlSize(.small)
      }.padding(4)
      
    }
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  
  return SettingsInterfaceActionManageView(interface: interface).environment(state)
}
