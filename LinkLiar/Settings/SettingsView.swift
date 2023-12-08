/*
 * Copyright (C)  halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
