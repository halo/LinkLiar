// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct InterfacesView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    // Container for all Interfaces
    VStack(alignment: .leading, spacing: 14) {

      // One row per Interface
      ForEach(state.nonHiddenInterfaces) { interface in
        InterfaceView(interface: interface)
      }

    }

  }
}

#Preview("InterfacesView") {
  let state = LinkState()
  Controller.queryInterfaces(state: state)
  return InterfacesView().environment(state)
}
