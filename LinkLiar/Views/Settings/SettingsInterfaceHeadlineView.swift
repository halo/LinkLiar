// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct SettingsInterfaceHeadlineView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {
    let activated = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != .hide },
      set: { value, _ in Config.Writer(state).setInterfaceActionHiddenness(interface: interface, isHidden: !value) })

    HStack(alignment: .firstTextBaseline) {
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: interface.iconName).imageScale(.large)

        VStack(alignment: .leading) {
          HStack(alignment: .firstTextBaseline) {
            Text(interface.name)
              .font(.title2)
            Text(interface.bsd.name)
              .font(.system(.body, design: .monospaced))
              .opacity(0.5)
          }
          Text(interface.hardMAC.address)
            .font(.system(.body, design: .monospaced))
            .opacity(0.5)
        }
      }
      Spacer()

      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Toggle(isOn: activated) {}.toggleStyle(.switch)
        }.padding(4)
      }
    }.padding(.bottom)
  }
}

#Preview("Hidden WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!
  state.configDictionary = [interface.hardMAC.address: ["action": "hide"],
                            "anonymous": "\( String(format: "%06X", Int(arc4random_uniform(0xffffff))) )\( String(format: "%06X", Int(arc4random_uniform(0xffffff))) )"]

  return SettingsInterfaceHeadlineView().environment(state)
    .environment(interface)
}

#Preview("Hidden Cable") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).last!
  state.configDictionary = [interface.hardMAC.address: ["action": "hide"]]

  return SettingsInterfaceHeadlineView().environment(state)
    .environment(interface)
}
