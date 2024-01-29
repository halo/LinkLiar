// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct PreferencesView: View {
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
  state.allInterfaces = Interfaces.all(.sync)

  return SettingsView.PreferencesView().environment(state)
}
