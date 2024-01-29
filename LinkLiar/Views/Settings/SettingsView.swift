// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

/// The main app preferences Window.
///
struct SettingsView: View {
  @Environment(LinkState.self) private var state

  /// We have static sidebar items and sidebar items views.
  /// Static is e.g. the "Welcome" and the "Troubleshoot" page.
  /// Dynamic is e.g. "Interface en1" and "Interface en2"
  /// Whatever is selected, we store as as String (not as `enum`).
  /// That gives us most flexibility.
  ///
  @State private var selectedFolder: String? = Pane.welcome.rawValue

  var body: some View {
    NavigationSplitView {
      List(selection: $selectedFolder) {
        Spacer()

        NavigationLink(value: Pane.welcome.rawValue) {
          Label("Welcome", systemImage: "figure.dance")
        }

        NavigationLink(value: Pane.community.rawValue) {
          Label("Community", systemImage: "bubble")
        }

        NavigationLink(value: Pane.preferences.rawValue) {
          Label("Settings", systemImage: "gear")
        }

        NavigationLink(value: Pane.vendors.rawValue) {
          Label("Vendors", systemImage: "apple.logo")
        }

        NavigationLink(value: Pane.help.rawValue) {
          Label("FAQ", systemImage: "book.pages")
        }

        NavigationLink(value: Pane.troubleshoot.rawValue) {
          Label("Troubleshoot", systemImage: "bandage")
        }

        NavigationLink(value: Pane.uninstall.rawValue) {
          Label("Uninstall", systemImage: "trash")
        }

        Spacer()
        Text("Interfaces")

        NavigationLink(value: Pane.defaultPolicy.rawValue) {
          Label("Interface Default", systemImage: "wand.and.stars.inverse")
        }

        ForEach(state.allInterfaces) { interface in
          let isHidden = state.config.policy(interface.hardMAC).action == .hide
          let opacity = isHidden ? 0.5 : 1
          NavigationLink(value: interface.id) {
            Label(interface.name, systemImage: interface.iconName).opacity(opacity)
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
  enum Pane: String {
    case welcome
    case preferences
    case vendors
    case troubleshoot
    case help
    case community
    case uninstall
    case defaultPolicy
  }
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)

  return SettingsView().environment(state)
}
