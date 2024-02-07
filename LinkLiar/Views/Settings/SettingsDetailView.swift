// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

/// Depending on which main setting category you chose in the sidebar,
/// this class determines the view for you to see in the right-side detail view.
///
struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state

  @Binding var selectedFolder: String?

  var body: some View {
    VStack {
      switch selectedFolder {
      case nil:
        EmptyView()

      case SettingsView.Pane.welcome.rawValue:
          SettingsView.WelcomeView().environment(state)

      case SettingsView.Pane.community.rawValue:
          SettingsView.CommunityView().environment(state)

      case SettingsView.Pane.help.rawValue:
          SettingsView.FaqView().environment(state)

      case SettingsView.Pane.preferences.rawValue:
          SettingsView.PreferencesView().environment(state)

      case SettingsView.Pane.vendors.rawValue:
          SettingsView.VendorsView().environment(state)

      case SettingsView.Pane.defaultPolicy.rawValue:
        SettingsView.FallbackPolicyView().environment(state)

      case SettingsView.Pane.troubleshoot.rawValue:
        SettingsView.TroubleshootView().environment(state)

      default:
        if let interface = state.allInterfaces.first(where: { $0.id == selectedFolder }) {
          SettingsView.InterfacePolicyView().environment(state)
            .environment(interface)
        } else {
          // The Interface currently edited was unplugged
          EmptyView()
        }
      }
    }
  }
}
