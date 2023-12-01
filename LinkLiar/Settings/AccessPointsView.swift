import SwiftUI

struct AccessPointsView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  var body: some View {
        
      VStack(alignment: .leading) {
        List {
          ForEach(state.config.policy(interface.hardMAC).accessPoints) { accessPointPolicy in
            Text(accessPointPolicy.ssid)
            Text(accessPointPolicy.softMAC.formatted)
          }
        }
        
        
      
    }
  }
}


//#Preview("Always Random") {
//  let state = LinkState()
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "random"]]
//  
//  return AccessPointView().environment(state).environment(interface)
//}
//
//
//#Preview("Specified MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "specify", "address": "aa:bb:cc:dd:ee:ff"]]
//  
//  return AccessPointView().environment(state).environment(interface)
//}
//
//
//#Preview("Original MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "original"]]
//  
//  return AccessPointView().environment(state).environment(interface)
//}
//
