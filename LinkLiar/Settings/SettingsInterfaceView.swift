// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct SettingsInterfaceView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  @State private var selectedTab = Tab.macaddress

  var body: some View {
    VStack {
      SettingsInterfaceHeadlineView().environment(state).environment(interface)

      if state.config.policy(interface.hardMAC).action == .hide {
        VStack {
          Spacer()
          HStack {
            Spacer()
            Text("This Interface is hidden from the menu bar\nand LinkLiar never changes its MAC address.")
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
            Spacer()
          }
          Spacer()
        }
      } else {
        // PoliciesView

        TabView {
          VStack {
            if state.config.policy(interface.hardMAC).action != .hide {
              PolicyIgnoreOrDefaultView().environment(state).environment(interface)

              if (state.config.policy(interface.hardMAC).action) != .ignore {
                PolicyDefaultOrCustomView().environment(state).environment(interface)

                if (state.config.policy(interface.hardMAC).action) != nil {
                  PolicyActionView().environment(state)
                    .environment(interface)
                }
              }
            }
            Spacer()
          }
          .tabItem {
            Text("MAC Address")
          }.padding()

          if interface.isWifi {
            AccessPointsView().environment(state).environment(interface)
              .tabItem {
                Text("Access Point")
              }
          }

          InterfacePrefixesView().environment(state).environment(interface)
            .tabItem {
              Text("Vendors")
            }

          DiagnoseInterfaceView().environment(state).environment(interface)
            .tabItem {
              Text("Diagnose")
            }
        }
      }
      Spacer()
    }.padding()
  }
}

extension SettingsInterfaceView {
  enum Tab: Int {
    case macaddress = 1
    case accesspoint = 2
  }
}

#Preview("Hidden") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "hide"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}

#Preview("Ignored WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "ignore"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}

#Preview("Ignored Cable") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).last!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "ignore"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}

#Preview("Default WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!

  return SettingsInterfaceView().environment(state).environment(interface)
}
