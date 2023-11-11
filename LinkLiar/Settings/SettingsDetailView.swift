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
        Text("Interface")
        Text(selectedFolder ?? "weird")
    }
//      Text(selectedFolder ?? "nothing")
//      SettingsDetailView(selectedFolder: selectedFolder).environment(state)


//    if let name = selectedFolder {
//      Text(name)
//    } else {
//      Text("Welcome")
//      Text(selectedFolder ?? "nothing")
//    }
  }
}

//
//private func selectDetail(_ folderName: String?) -> View {
//  guard let name = folderName else {
//    return EmptyView()
//  }
//  
//  switch name {
//    case "troubleshoot":
//      return SettingsTroubleshootView().environment(state)
//    default:
//      return loadInterfaceSettings(state: state, interfaceId: name)
//  }
//}
//
//private func loadInterfaceSettings(state: LinkState, interfaceId: Interface.ID?) -> View {
//  guard let interface = state.interfaces.first(where: { $0.id == interfaceId }) else {
//    return Text("Unknown Interface")
//  }
//
//  state.settingsEditingInterface = interface
//  return SettingsInterfaceView().environment(state)
//}
