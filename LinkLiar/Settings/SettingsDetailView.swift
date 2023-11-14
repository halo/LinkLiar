import SwiftUI

struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state
  
  @Binding var selectedFolder: String?
  
  var body: some View {
    VStack {
      
      switch selectedFolder {
        case nil:
          Text("Welcome")
        case SettingsView.panes.general.rawValue:
          Text("General")
        case SettingsView.panes.troubleshoot.rawValue:
          SettingsTroubleshootView().environment(state)
        default:
          if let interface = state.interfaces.first(where: { $0.id == selectedFolder }) {
            SettingsInterfaceView().environment(state)
                                   .environment(interface)
          } else {
            // The Interface currently edited was unplugged
            EmptyView()
          }
      }
    }
        
  }
  
}
