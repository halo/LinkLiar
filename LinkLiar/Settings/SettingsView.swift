import SwiftUI
import ServiceManagement

struct SettingsView: View {
  @Environment(LinkState.self) private var state

  @State private var selectedFolder: String?
  
  var body: some View {
    NavigationSplitView {
      List(selection: $selectedFolder) {

        Spacer()

        NavigationLink(value: panes.general.rawValue) {
          Label("Welcome", systemImage: "figure.run")
        }
        
        NavigationLink(value: panes.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "cross.case")
        }

        Spacer()
        Text("Interfaces")
        
        NavigationLink(value: panes.defaultPolicy.rawValue) {
          Label("Default", systemImage: "movieclapper")
        }
        
        ForEach(state.interfaces) { interface in
          NavigationLink(value: interface.id) {
            Label(interface.displayName, systemImage: interface.iconName)
          }
        }
              }
      .navigationSplitViewColumnWidth(180)
      .toolbar(removing: .sidebarToggle)
      
    } detail: {
      SettingsDetailView(selectedFolder: $selectedFolder).environment(state)
    }.presentedWindowStyle(.hiddenTitleBar)
    
  }
}

extension SettingsView {
  enum panes: String {
    case general = "general"
    case troubleshoot = "troubleshoot"
    case defaultPolicy = "default_policy"
  }
}
