import SwiftUI

struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state
  
  @Binding var selectedFolder: String?

  var body: some View {
    switch selectedFolder {
      case nil:
        Text("Welcome")
      case SettingsView.panes.general.rawValue:
        Text("General")
      case SettingsView.panes.troubleshoot.rawValue:
        SettingsTroubleshootView().environment(state)
      default:
        SettingsInterfaceView(hardMAC: $selectedFolder).environment(state)
    }
  }
}
