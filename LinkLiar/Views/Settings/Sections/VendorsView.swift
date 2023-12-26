// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct VendorsView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      VStack {
        Text("Vendors...")
      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)

  return SettingsView.PreferencesView().environment(state)
}
