import SwiftUI

struct SettingsInterfaceHideOrIgnoreView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
    
    // false means it is hidden
    // true means it is anything else
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action() != .hide },
      set: { value,_ in ConfigWriter.setInterfaceActionHiddenness(interface: interface, isHidden: !value, state: state) } )
    
    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Show in Menu Bar")
          if value.wrappedValue {
            Text("This Interface is currently shown in the menu bar list. If you turn this off, you essentially tell LinkLiar that you never want to see this Interface again and that its MAC address need not be managed by LinkLiar.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("This Interface is currently hidden from the menu bar. If you turn this on, you will see the Interface in the menu bar and you can configure LinkLiar to manage its MAC address.")
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
  
  return SettingsInterfaceHideOrIgnoreView().environment(state)
                                            .environment(interface)
}
