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

struct SettingsDetailView: View {
  @Environment(LinkState.self) private var state

  @Binding var selectedFolder: String?

  var body: some View {
    VStack {

      switch selectedFolder {
        case nil:
          EmptyView()
        case SettingsView.panes.welcome.rawValue:
          Text("Welcome")
        case SettingsView.panes.defaultPolicy.rawValue:
          SettingsInterfaceFallbackView().environment(state)
        case SettingsView.panes.troubleshoot.rawValue:
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
