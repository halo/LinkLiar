// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct SettingsInterfaceHeadlineView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {

    let activated = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != .hide },
      set: { value, _ in ConfigWriter.setInterfaceActionHiddenness(interface: interface, isHidden: !value, state: state) })

    HStack(alignment: .firstTextBaseline) {
      HStack(alignment: .firstTextBaseline) {

        Image(systemName: interface.iconName).imageScale(.large)

        VStack(alignment: .leading) {
          HStack(alignment: .firstTextBaseline) {
            Text(interface.displayName)
              .font(.title2)
            Text(interface.BSDName)
              .font(.system(.body, design: .monospaced))
              .opacity(0.5)
          }
          Text(interface.hardMAC.humanReadable(config: state.config))
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
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "hide"], "anonymous": "\( String(format: "%06X", Int(arc4random_uniform(0xffffff))) )\( String(format: "%06X", Int(arc4random_uniform(0xffffff))) )"]

  return SettingsInterfaceHeadlineView().environment(state)
    .environment(interface)
}

#Preview("Hidden Cable") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).last!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "hide"]]

  return SettingsInterfaceHeadlineView().environment(state)
    .environment(interface)
}
