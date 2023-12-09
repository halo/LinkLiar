// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state

  @Binding var selectedFolder: String?

  var body: some View {
    VStack {
      switch selectedFolder {
      case nil:
        EmptyView()

      case SettingsView.Panes.welcome.rawValue:
        Text("Welcome")

      case SettingsView.Panes.defaultPolicy.rawValue:
        SettingsInterfaceFallbackView().environment(state)

      case SettingsView.Panes.troubleshoot.rawValue:
        SettingsTroubleshootView().environment(state)

      default:
        if let interface = state.allInterfaces.first(where: { $0.id == selectedFolder }) {
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
