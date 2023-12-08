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

struct MenuView: View {
  @State var observer: NSKeyValueObservation?
  @Environment(LinkState.self) private var state

  @State var selectedItem: String = ""
  @State var items = ["One", "Two"]
  @State var isHovering: Bool = false

  var body: some View {
    VStack {
      RegisterDaemonView().environment(state)
      ApproveDaemonView().environment(state)

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
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)
  return MenuView().environment(state)
}

#Preview("Daemon not registered") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)
  state.daemonRegistration = .notRegistered
  return MenuView().environment(state)
}

#Preview("Daemon requires approval") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)
  state.daemonRegistration = .requiresApproval
  return MenuView().environment(state)
}

#Preview("Wanting to quit") {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)
  state.wantsToQuit = true
  return MenuView().environment(state)
}

#Preview("No Interfaces") {
  let state = LinkState()
  state.allInterfaces = []
  return MenuView().environment(state)
}
