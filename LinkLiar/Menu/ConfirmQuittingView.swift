// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI
import ServiceManagement

struct ConfirmQuittingView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    if state.wantsToQuit {
      VStack {
        Divider().padding(.top, 3).padding(.bottom, 5)

        Image(systemName: "door.right.hand.closed")
          .font(.system(size: 40))
          .padding(.bottom, 4)

        Text("LinkLiar will continue to run in\nin the background. You can\nchange this in the settings.")
          .padding(.bottom, 4)

        Button(action: Controller.quitForReal) {
          Text("Quit this Menu")
        }.padding(.bottom, 4)
          .buttonStyle(.borderedProminent)

        Button(action: { Controller.wantsToStay(state) }, label: {
          Text("Cancel")
        }).padding(.bottom, 4)
          .buttonStyle(.plain)
      }

    }
  }
}

#Preview {
  let state = LinkState()
  state.wantsToQuit = true
  return ConfirmQuittingView().environment(state)
}
