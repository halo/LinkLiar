// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct PolicyDefaultOrCustomView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {
    // false means it is default
    // true means it has an action
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != nil },
      set: { value, _ in Config.Writer(state).setInterfaceAction(interface: interface, action: (value ? .random : nil)) })

    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Customize Interface")
          if value.wrappedValue {
            Text("This Interface is managed using the custom rules below. If you turn this off, LinkLiar will do to this Interface whatever you defined as Interface default.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("LinkLiar currently does to this Interface whatever you configured as a default for Interfaces. If you turn this on, you can define custom rules for this particular Interface.")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        Spacer()

        Toggle(isOn: value) {}
          .toggleStyle(.switch)
          .controlSize(.small)
      }.padding(4)
    }
  }
}

#Preview {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!

  return PolicyDefaultOrCustomView().environment(state)
                                            .environment(interface)
}
