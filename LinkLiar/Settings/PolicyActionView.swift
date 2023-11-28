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
              Text("Always Keep Random")
            }
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .specify, state: state) }) {
              Text("Specific MAC Address")
            }
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .original, state: state) }) {
              Text("Keep Original MAC Address")
            }
            Divider()
            
          } label: {
            switch actionValue.wrappedValue {
              case .random:
                Text("Always Keep Random")
                
              case .specify:
                Text("Specific MAC Address")
                
              case .original:
                Text("Keep Original MAC Address")
                
              default:
                Text("Unknown")
            }
            Text(actionValue.wrappedValue?.rawValue ?? "?")
            
          }.menuStyle(.borderlessButton)
            .fixedSize()
          
          Spacer()
        }.padding(.top, 4)
        
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
              .border(.tertiary)
              .font(.system(.title3, design: .monospaced))
              .frame(width: 200)
              
            case .original:
              Text("LinkLiar ensures that this Interface always has its original hardware MAC address.")
                .font(.caption)
                .foregroundColor(.secondary)

            default:
              Text("Invalid")
          }
          
        }.padding([.bottom, .horizontal], 4)
        
      }
    }
  }
}


#Preview("Always Random") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "random"]]
  
  return PolicyActionView().environment(state).environment(interface)
}


#Preview("Specified MAC") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "specify", "address": "aa:bb:cc:dd:ee:ff"]]
  
  return PolicyActionView().environment(state).environment(interface)
}


#Preview("Original MAC") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "original"]]
  
  return PolicyActionView().environment(state).environment(interface)
}

