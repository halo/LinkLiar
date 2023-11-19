import SwiftUI

struct PolicyIgnoreOrDefaultView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
    
    // false means it is ignored
    // true means it is anything else
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != .ignore },
      set: { value,_ in ConfigWriter.setInterfaceActionIgnoredness(interface: interface, isIgnored: !value, state: state) } )
    
    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Manage MAC address")
          if value.wrappedValue {
            Text("LinkLiar may change the MAC address of this interface. If you turn this off, LinkLiar will never change this Interface and not warn you if it has its original MAC address.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("This Interface is currently being ignored by LinkLiar. If you turn this on, LinkLiar will start managing its MAC address and warn you whenever it uses its original MAC address.")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        Spacer()
        
        Toggle(isOn: value) {}
          .toggleStyle(.switch)
          .controlSize(.small)
        
      }.padding(4)
    }
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  
  return PolicyDefaultOrCustomView().environment(state)
                                            .environment(interface)
}
