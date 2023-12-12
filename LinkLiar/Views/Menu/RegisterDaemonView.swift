// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct RegisterDaemonView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    if state.daemonRegistration == .notRegistered {
      VStack {
        Image(systemName: "sparkles")
          .font(.system(size: 40))
          .padding(.bottom, 4)

        Text("The LinkLiar background service\nis not installed yet. Please install\nit first.")

        Button(action: { Controller.registerDaemon(state: state) }) {
          Text("Install")
        }
        .buttonStyle(.borderedProminent)

        Divider().padding(.vertical, 5)
      }
    }
  }
}

#Preview {
  let state = LinkState()
  state.daemonRegistration = .notRegistered
  return RegisterDaemonView().environment(state)
}
