import SwiftUI

struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state
  
  @Binding var selectedFolder: String?
  
  var body: some View {
    VStack {
      
      switch selectedFolder {
        case nil:
          EmptyView()
        case SettingsView.panes.welcome.rawValue:
          Text("Welcome")
        case SettingsView.panes.defaultPolicy.rawValue:
          SettingsInterfaceFallbackView().environment(state)
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
