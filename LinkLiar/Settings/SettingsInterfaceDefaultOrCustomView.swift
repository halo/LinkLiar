import SwiftUI

struct SettingsInterfaceDefaultOrCustomView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
    
    // false means it is default
    // true means it has an action
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action() != nil },
      set: { value,_ in ConfigWriter.setInterfaceAction(interface: interface, action: (value ? .random : nil), state: state) } )
    
    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Custom MAC address")
          if value.wrappedValue {
            Text("LinkLiar currently doasdyou configured as a default for Interfaces. If you turn this off, LinkLiar will not do anything with this Interface and not warn you if it has its original MAC address.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("This Interface is cuasdr. If you turn this on, LinkLiar will start managing its MAC address and warn you whenever it uses its original MAC address.")
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
  
  return SettingsInterfaceDefaultOrCustomView().environment(state)
                                            .environment(interface)
}
