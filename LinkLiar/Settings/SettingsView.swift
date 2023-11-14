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
        
        
        ForEach(state.interfaces) { interface in
          NavigationLink(value: interface.id) {
            Label(interface.displayName, systemImage: interface.iconName)
          }
        }
        
        Divider().padding(.top, -5)
        
        NavigationLink(value: panes.defaultPolicy.rawValue) {
          Label("Interface Default", systemImage: "movieclapper")
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

#Preview {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  
  return SettingsView().environment(state)
  
}

