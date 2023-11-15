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
          Label("Welcome", systemImage: "figure.dance")
        }
        
        NavigationLink(value: panes.help.rawValue) {
          Label("Help", systemImage: "book.pages")
        }
        
        NavigationLink(value: panes.community.rawValue) {
          Label("Community", systemImage: "bubble")
        }

        NavigationLink(value: panes.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "bandage")
        }
        
        NavigationLink(value: panes.uninstall.rawValue) {
          Label("Uninstall", systemImage: "trash")
        }
        
        Spacer()
        Text("Interfaces")
        
        NavigationLink(value: panes.defaultPolicy.rawValue) {
          Label("Interface Default", systemImage: "wand.and.stars.inverse")
        }

        ForEach(state.interfaces) { interface in
          NavigationLink(value: interface.id) {
            Label(interface.displayName, systemImage: interface.iconName)
          }
        }
        
        Spacer()
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
    case help = "help"
    case community = "community"
    case uninstall = "uninstall"
    case defaultPolicy = "default_policy"
  }
}

#Preview {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  
  return SettingsView().environment(state)
  
}

