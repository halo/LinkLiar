import SwiftUI
import ServiceManagement

struct SettingsPoliciesView: View {
  @Environment(LinkState.self) private var state
  @State private var selectedInterfaceId: Interface.ID?
  
  @State private var options = [
    "Troubleshoot",
  ]
  
  @State private var selectedFolder: String?
  
  var body: some View {
//    options.append(state.interfaces.map({ $0.displayName }))
    NavigationSplitView {
            
      List(selection: $selectedFolder) {
        NavigationLink(value: panes.general.rawValue) {
          Label("General", systemImage: "house")
        }

        Spacer()
        Text("Interfaces")

        ForEach(state.interfaces) { interface in
          NavigationLink(value: interface.id) {
            Label(interface.BSDName, systemImage: "house")
          }
        }
        
        NavigationLink(value: panes.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "house")
        }
      }
      
      .navigationSplitViewColumnWidth(180)
      .toolbar(removing: .sidebarToggle)
      // List(model.departments, selection: $departmentId) { department in
      
      //      List(state.interfaces, selection: $selectedInterfaceId) { interface in
      //        VStack {
      //          HStack {
      //            Text(interface.displayName)
      //            Text(interface.BSDName)
      //          }
      ////          HStack {
      ////            if (state.settingsPolicyForInterface == interface) {
      ////              Text("selected")
      ////            } else {
      ////              Text("n")
      ////
      ////            }
      ////          }
      //        }
      //      }
      
    } detail: {
      if let folderName = $selectedFolder.wrappedValue {
      
        if let interface = state.interfaces.first(where: { $0.id == folderName }) {
          Text(interface.displayName)
        }
        else {
          switch folderName {
            case "troubleshoot":
              SettingsTroubleshootView().environment(state)
            default:
              Text(folderName)
          }
        }
//
//        Text(interface.displayName)
      } else {
        Text("Nothing")
      }
    }.presentedWindowStyle(.hiddenTitleBar)
//    .navigationTitle("Transparent")
//    .tabItem {
//      Image(systemName: "bolt.fill")
//      Text("Interfaces")
//    }
  }
  
  //  /// Chooses which ``Interface`` policy is currently edited.
  //  private func setInterface(_ interface: Interface) {
  //    state.settingsPolicyForInterface = interface
  //  }
}

extension SettingsPoliciesView {
  enum panes: String {
    case general = "general"
    case troubleshoot = "troubleshoot"
  }
}
