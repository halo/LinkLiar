/*
 * Copyright (C)  halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
