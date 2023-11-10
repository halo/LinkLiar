import SwiftUI

struct InterfacesView: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    
    // Container for Interfaces
    VStack(alignment: .leading, spacing: 14) {
      ForEach(state.interfaces) { interface in
        // One Interface
        InterfaceView(interface: interface)
      }
    }.padding([.horizontal, .top])
    
  }
}

#Preview("InterfacesView") {
  let state = LinkState()
  Controller.queryInterfaces(state: state)
  return InterfacesView().environment(state)
}
