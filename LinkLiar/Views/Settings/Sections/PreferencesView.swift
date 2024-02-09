// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct PreferencesView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {

        GroupBox {
          HStack(alignment: .top) {
            let allowScan = Binding<Bool>(
              get: { !state.config.general.denyScan },
              set: { value, _ in
                value ? Config.Writer(state).allowScan() : Config.Writer(state).denyScan()
              }
            )

            VStack(alignment: .leading, spacing: 3) {
              Text("Allow Wi-Fi Network Scanning")
              if allowScan.wrappedValue {
                Text("""
                     Currently, LinkLiar scans for Wi-Fi networks if you configured \
                     an interface to have a specific MAC depending on the presence of a Wi-Fi network SSID. \
                     Deactivate this, to prevent LinkLiar from ever scanning for networks.
                     """)
             .font(.caption)
             .foregroundColor(.secondary)
              } else {
                Text("""
                     Currently, LinkLiar will never scan for Wi-Fi networks. \
                     Even if you configured an Interface to have a specific MAC address \
                     if a certain Wi-Fi network SSID is found. Activate this to stat scanning for networks.
                     """)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            Spacer()
            Toggle(isOn: allowScan) {}
              .toggleStyle(.switch)
              .controlSize(.small)
          }.padding(4)
        }

      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(.sync)

  return SettingsView.PreferencesView().environment(state)
}
