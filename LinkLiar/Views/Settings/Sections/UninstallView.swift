// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct UninstallView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      VStack {
        Text("Preferences...")
      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.UninstallView().environment(state)
}
