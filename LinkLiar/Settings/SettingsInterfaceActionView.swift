import SwiftUI

struct SettingsInterfaceActionView: View {
  @Environment(LinkState.self) private var state
  
  @State var interface: Interface?
  @State var action: Interface.Action?
  
  var body: some View {
    if let interface, let action {
      
      Button(action: {}) {
        GroupBox {
          VStack(alignment: .leading, spacing: 4) {
            Label(action.rawValue.capitalized, systemImage: "wand.and.stars")
              .font(.headline)
//              .foregroundColor(.accentColor)
            Text("Lorem \(interface.BSDName) Ipsum Wow this is good")
          }
        }
        .border(Color(.controlAccentColor))
        .padding([.horizontal, .bottom])

      }.buttonStyle(.plain)
      
    } else {
      Text("Could not find Interface")
    }
  }
}


#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first
  let action = Interface.Action.ignore
  
  return SettingsInterfaceActionView(interface: interface, action: action).environment(state)
}
