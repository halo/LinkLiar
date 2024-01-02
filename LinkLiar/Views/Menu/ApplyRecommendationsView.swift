// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

struct ApplyRecommendationsView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    if state.daemonRegistration == .enabled && !state.config.isRecommended && !state.config.general.isDismissingRecommendation {
      VStack {
        Image(systemName: "play.circle")
          .font(.system(size: 40))
          .padding(.bottom, 4)

        Text("LinkLiar is fully installed,\nbut doesn't do anything yet.")
          .padding(.bottom, 4)

        Text("Would you like to apply\nthe recommended settings?")
          .padding(.bottom, 4)

        Button(action: { Config.Writer(state).applyRecommendedSettings() }, label: {
          Text("Yes, please!")
        }).padding(.bottom, 4)
          .buttonStyle(.borderedProminent)

        Button(action: { Config.Writer(state).dismissRecommendedSettings() }, label: {
          Text("Dismiss")
        }).padding(.bottom, 4)
          .buttonStyle(.accessoryBar)

      }

      Divider().padding(.vertical, 5)
    }
  }
}

#Preview {
  let state = LinkState()
  state.daemonRegistration = .enabled
  return ApplyRecommendationsView().environment(state).frame(width: 200)
}
