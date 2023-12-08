// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI
import ServiceManagement

struct SettingsView: View {
  @Environment(LinkState.self) private var state

  @State private var selectedFolder: String? = Panes.welcome.rawValue

  var body: some View {
    NavigationSplitView {
      List(selection: $selectedFolder) {
        Spacer()

        NavigationLink(value: Panes.welcome.rawValue) {
          Label("Welcome", systemImage: "figure.dance")
        }

        NavigationLink(value: Panes.settings.rawValue) {
          Label("Settings", systemImage: "gear")
        }

        NavigationLink(value: Panes.help.rawValue) {
          Label("FAQ", systemImage: "book.pages")
        }

        NavigationLink(value: Panes.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "bandage")
        }

        NavigationLink(value: Panes.community.rawValue) {
          Label("Community", systemImage: "bubble")
        }

        NavigationLink(value: Panes.uninstall.rawValue) {
          Label("Uninstall", systemImage: "trash")
        }

        Spacer()
        Text("Interfaces")

        NavigationLink(value: Panes.defaultPolicy.rawValue) {
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
  enum Panes: String {
    case welcome
    case settings
    case troubleshoot
    case help
    case community
    case uninstall
    case defaultPolicy
  }
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)

  return SettingsView().environment(state)

}
