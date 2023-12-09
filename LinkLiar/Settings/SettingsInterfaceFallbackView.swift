// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct SettingsInterfaceFallbackView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    let actionValue = Binding<Interface.Action?>(
      get: { state.config.fallbackPolicy.action },
      set: { value, _ in Configuration.Writer(state).setFallbackInterfaceAction(action: value) })

    VStack(alignment: .leading) {
      Text("Default Interface Settings")
        .font(.title2)
        .padding(.top)

      GroupBox {
        VStack(alignment: .leading) {
          HStack(alignment: .top) {
            Menu {
              Button(action: { Configuration.Writer(state).setFallbackInterfaceAction(action: .random) }) {
                Text("Always Keep Random")
              }
              Button(action: { Configuration.Writer(state).setFallbackInterfaceAction(action: .original) }) {
                Text("Keep Original MAC Address")
              }
              Button(action: { Configuration.Writer(state).setFallbackInterfaceAction(action: nil) }) {
                Text("Ignore")
              }
              Divider()
            } label: {
              switch actionValue.wrappedValue {
                case .random:
                  Text("Always Keep Random")

                case .original:
                  Text("Keep Original MAC Address")

                default:
                  Text("Ignore")
              }
              Text(actionValue.wrappedValue?.rawValue ?? "?")
            }.menuStyle(.borderlessButton)
              .fixedSize()

            Spacer()
          }.padding(4)

          VStack(alignment: .leading) {
            switch actionValue.wrappedValue {
              case .random:
                Text("LinkLiar ensures that an Interface always has a random MAC address.")
                  .font(.caption)
                  .foregroundColor(.secondary)

              case .original:
                Text("LinkLiar ensures that an Interface always has its original hardware MAC address.")
                  .font(.caption)
                  .foregroundColor(.secondary)

              default:
                Text("LinkLiar warns if an Interface is leaking its MAC address, but LinkLiar won't modify the MAC address.")
            }
          }.padding(4)
        }
      }
      Spacer()
    }.padding()
  }
}

#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!

  return SettingsInterfaceFallbackView().environment(state)
    .environment(interface)
}
