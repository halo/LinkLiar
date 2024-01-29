// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct InterfacePolicyView: View {
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

            //          InterfacePrefixesView().environment(state).environment(interface)
            //            .tabItem {
            //              Text("Vendors")
            //            }

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
}

extension SettingsView.InterfacePolicyView {
  enum Tab: Int {
    case macaddress = 1
    case accesspoint = 2
  }
}

#Preview("Hidden") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!
  state.configDictionary = [interface.hardMAC.address: ["action": "hide"]]

  return SettingsView.InterfacePolicyView().environment(state).environment(interface)
}

#Preview("Ignored WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!
  state.configDictionary = [interface.hardMAC.address: ["action": "ignore"]]

  return SettingsView.InterfacePolicyView().environment(state).environment(interface)
}

#Preview("Ignored Cable") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).last!
  state.configDictionary = [interface.hardMAC.address: ["action": "ignore"]]

  return SettingsView.InterfacePolicyView().environment(state).environment(interface)
}

#Preview("Default WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!

  return SettingsView.InterfacePolicyView().environment(state).environment(interface)
}
