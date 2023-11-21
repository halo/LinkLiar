import SwiftUI
import ServiceManagement

struct SettingsView: View {
  @Environment(LinkState.self) private var state
  
  @State private var selectedFolder: String? = panes.welcome.rawValue
  
  var body: some View {
    NavigationSplitView {
      List(selection: $selectedFolder) {
        Spacer()

        NavigationLink(value: panes.welcome.rawValue) {
          Label("Welcome", systemImage: "figure.dance")
        }
        
        NavigationLink(value: panes.settings.rawValue) {
          Label("Settings", systemImage: "gear")
        }
        
        NavigationLink(value: panes.help.rawValue) {
          Label("FAQ", systemImage: "book.pages")
        }
        
        NavigationLink(value: panes.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "bandage")
        }
        
        NavigationLink(value: panes.community.rawValue) {
          Label("Community", systemImage: "bubble")
        }

        NavigationLink(value: panes.uninstall.rawValue) {
          Label("Uninstall", systemImage: "trash")
        }
        
        Spacer()
        Text("Interfaces")
        
        NavigationLink(value: panes.defaultPolicy.rawValue) {
          Label("Interface Default", systemImage: "wand.and.stars.inverse")
        }

        ForEach(state.allInterfaces) { interface in
          let isHidden = state.config.policy(interface.hardMAC).action == .hide
          let opacity = isHidden ? 0.5 : 1
          NavigationLink(value: interface.id) {
            Label(interface.displayName, systemImage: interface.iconName).opacity(opacity)
          }
        }
        
        Spacer()
      }
      .toolbar(removing: .sidebarToggle)
      .navigationSplitViewColumnWidth(155)

    } detail: {
      SettingsDetailView(selectedFolder: $selectedFolder).environment(state)
    }.presentedWindowStyle(.hiddenTitleBar)
      .frame(minWidth: 650, idealWidth: 650, maxWidth: 650, minHeight: 500, idealHeight: 500, maxHeight: 800)

  }
}

extension SettingsView {
  enum panes: String {
    case welcome = "welcome"
    case settings = "settings"
    case troubleshoot = "troubleshoot"
    case help = "help"
    case community = "community"
    case uninstall = "uninstall"
    case defaultPolicy = "default_policy"
  }
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)
  
  return SettingsView().environment(state)
  
}

