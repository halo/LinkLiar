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
