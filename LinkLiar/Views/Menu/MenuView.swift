// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct MenuView: View {
  @State var observer: NSKeyValueObservation?
  @Environment(LinkState.self) private var state

  @State var selectedItem: String = ""
  @State var items = ["One", "Two"]
  @State var isHovering = false

  var body: some View {
    VStack {
      RegisterDaemonView().environment(state)
      ApproveDaemonView().environment(state)
      ApplyRecommendationsView().environment(state)

      InterfacesView().environment(state)

      if !state.nonHiddenInterfaces.isEmpty {
        Divider().padding([.top, .bottom], 3)
      }

      HStack {
        SettingsLink {
//          Image(systemName: "gear").imageScale(.medium)
          Text("Settings")
        }.keyboardShortcut(",", modifiers: .command)
          .buttonStyle(.accessoryBar)

        Button("Quit") {
          Controller.wantsToQuit(state)
        }.keyboardShortcut("q")
          .buttonStyle(.accessoryBar)
      }

      ConfirmQuittingView().environment(state)
    }.padding(12)
      .fixedSize()
      .onAppear {
        // See https://damian.fyi/swift/2022/12/29/detecting-when-a-swiftui-menubarextra-with-window-style-is-opened.html
        // For some reason this also triggers when the Settings view received or loosed focus.
        // I guess that's a good thing.
        observer = NSApplication.shared.observe(\.keyWindow) { _, _ in
          NotificationCenter.default.post(name: .menuBarAppeared, object: nil)
        }
      }
  }
}

#Preview("Standard") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)
  return MenuView().environment(state)
}

#Preview("Daemon not registered") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)
  state.daemonRegistration = .notRegistered
  return MenuView().environment(state)
}

#Preview("Daemon requires approval") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)
  state.daemonRegistration = .requiresApproval
  return MenuView().environment(state)
}

#Preview("Wanting to quit") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)
  state.wantsToQuit = true
  return MenuView().environment(state)
}

#Preview("No Interfaces") {
  let state = LinkState()
  state.allInterfaces = []
  return MenuView().environment(state)
}
