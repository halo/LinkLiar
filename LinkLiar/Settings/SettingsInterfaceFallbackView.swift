import SwiftUI

struct SettingsInterfaceFallbackView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    
    let actionValue = Binding<Interface.Action?>(
      get: { state.config.fallbackPolicy.action },
      set: { value,_ in ConfigWriter.setFallbackInterfaceAction(action: value, state: state) } )
    
    VStack(alignment: .leading) {
      
      Text("Default Interface Settings")
        .font(.title2)
        .padding(.top)
      
      GroupBox {
        VStack(alignment: .leading) {
          
          HStack(alignment: .top) {
            Menu {
              Button(action: { ConfigWriter.setFallbackInterfaceAction(action: .random, state: state) }) {
                Text("Always Keep Random")
              }
              Button(action: { ConfigWriter.setFallbackInterfaceAction(action: .original, state: state) }) {
                Text("Keep Original MAC Address")
              }
              Divider()
              
            } label: {
              switch actionValue.wrappedValue {
                case .random:
                  Text("Always Keep Random")
                  
                case .original:
                  Text("Keep Original MAC Address")
                  
                default:
                  Text("Unknown")
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
                
              case .original:
                Text("LinkLiar ensures that this Interface always has its original hardware MAC address.")
                  .font(.caption)
                  .foregroundColor(.secondary)
                
              default:
                Text("Invalid")
            }
            
          }.padding(4)
          
        }
      }
      Spacer()
    }.padding()
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  
  return SettingsInterfaceFallbackView().environment(state)
    .environment(interface)
}
