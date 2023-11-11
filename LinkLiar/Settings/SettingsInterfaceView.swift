import SwiftUI

struct SettingsInterfaceView: View {
  @Environment(LinkState.self) private var state

  @Binding var hardMAC: String?

  var body: some View {
    if let interface {
      VStack {
        HStack {
          Text(interface.displayName)
          Text(interface.BSDName)
        }
        
        GroupBox {
          Text("Random")
        }.background(.red).frame(maxWidth: .infinity)
        
        GroupBox {
          Text("Ignore")
        }
        
        GroupBox {
          Text("Hide")
        }
      }.background(.green).frame(alignment: .leading)
      
    } else {
      Text("Could not find Interface \(hardMAC ?? "?")")
    }

    
  }

  private var interface: Interface? {
    state.interfaces.first(where: { $0.id == hardMAC })
  }
}

//#Preview {
//  let state = LinkState()
//  state.interfaces = Interfaces.all(asyncSoftMac: false)
//  return SettingsInterfaceView(hardMAC: "aa:bb:cc:dd:ee:ff").environment(state)
//}
