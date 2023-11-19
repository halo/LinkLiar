import SwiftUI

struct PolicyActionView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
    
    // false means it is ignored
    // true means it is anything else
    let value = Binding<Interface.Action?>(
      get: { state.config.policy(interface.hardMAC).action },
      set: { value,_ in ConfigWriter.setInterfaceAction(interface: interface, action: value, state: state) } )
    
    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Custom MAC address")
          
          if let action = value.wrappedValue {
            Text(action.rawValue)
          } else {
            Text("None")
          }
//
//          if value.wrappedValue {
//            Text("asd")
//              .font(.caption)
//              .foregroundColor(.secondary)
//          } else {
//            Text("jkl")
//              .font(.caption)
//              .foregroundColor(.secondary)
//          }
        }
        Spacer()
        
        Menu {
          Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .random, state: state) }) {
            Text("Random")
          }
          Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .specify, state: state) }) {
            Text("Specify")
          }
          Divider()
          Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: nil, state: state) }) {
            Text("Default")
          }
          
        } label: {
          Text("ho")
        }.menuStyle(.borderlessButton).fixedSize()

        
//        Toggle(isOn: value) {}
//          .toggleStyle(.switch)
//          .controlSize(.small)
        
      }.padding(4)
    }
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  
  return PolicyActionView().environment(state)
                                       .environment(interface)
}
