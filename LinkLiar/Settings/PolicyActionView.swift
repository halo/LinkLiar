import SwiftUI

struct PolicyActionView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
    
    let actionValue = Binding<Interface.Action?>(
      get: { state.config.policy(interface.hardMAC).action },
      set: { value,_ in ConfigWriter.setInterfaceAction(interface: interface, action: value, state: state) } )
    
    let specificAddress = Binding<String>(
      get: { state.config.policy(interface.hardMAC).address?.formatted ?? "" },
      set: { value,_ in ConfigWriter.setInterfaceAddress(interface: interface, address: MACAddress(value), state: state) } )
    
    GroupBox {
      VStack(alignment: .leading) {
        
        
        HStack(alignment: .top) {
          Menu {
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .random, state: state) }) {
              Text("Random")
            }
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .specify, state: state) }) {
              Text("Specify")
            }
            Divider()
            
          } label: {
            switch actionValue.wrappedValue {
              case .random:
                Text("Always Keep Random")
                
              case .specify:
                Text("Specific MAC Address")
                
              default:
                Text("Invalid")
            }
            Text(actionValue.wrappedValue?.rawValue ?? "?")
            
          }.menuStyle(.borderlessButton)
            .fixedSize()
          
          Spacer()
        }.padding(4)
        
        VStack(alignment: .leading) {
          
          switch actionValue.wrappedValue {
            case .random:
              Text("LinkLiar ensures that this Interface always has a random MAC address.")
                .font(.caption)
                .foregroundColor(.secondary)
              
            case .specify:
              Text("You specify a particular MAC address and LinkLiar sees to it that this Interface always has this address.")
                .font(.caption)
                .foregroundColor(.secondary)

              TextField("MAC Address",
                        value: specificAddress,
                        formatter: MACAddressFormatter(),
                        prompt: Text("e.g. aa:bb:cc:dd:ee:ff")
              )
              .disableAutocorrection(true)
              .border(.secondary)
              
            default:
              Text("Invalid")
          }
          
        }.padding(4)
        
      }
    }
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  
  return PolicyActionView().environment(state)
    .environment(interface)
}
