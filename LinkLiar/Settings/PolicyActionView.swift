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

struct PolicyActionView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {

    let actionValue = Binding<Interface.Action?>(
      get: { state.config.policy(interface.hardMAC).action },
      set: { value, _ in ConfigWriter.setInterfaceAction(interface: interface, action: value, state: state) })

    let specificAddress = Binding<String>(
      get: { state.config.policy(interface.hardMAC).address?.formatted ?? "" },
      set: { value, _ in ConfigWriter.setInterfaceAddress(interface: interface, address: MACAddress(value), state: state) })

    GroupBox {
      VStack(alignment: .leading) {

        HStack(alignment: .top) {
          Menu {
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .random, state: state) }) {
              Text("Always Keep Random")
            }
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .specify, state: state) }) {
              Text("Specific MAC Address")
            }
            Button(action: { ConfigWriter.setInterfaceAction(interface: interface, action: .original, state: state) }) {
              Text("Keep Original MAC Address")
            }
            Divider()

          } label: {
            switch actionValue.wrappedValue {
              case .random:
                Text("Always Keep Random")

              case .specify:
                Text("Specific MAC Address")

              case .original:
                Text("Keep Original MAC Address")

              default:
                Text("Unknown")
            }
            Text(actionValue.wrappedValue?.rawValue ?? "?")

          }.menuStyle(.borderlessButton)
            .fixedSize()

          Spacer()
        }.padding(.top, 4)

        VStack(alignment: .leading) {

          switch actionValue.wrappedValue {
            case .random:
              Text("LinkLiar ensures that this Interface always has a random MAC address.")
                .font(.caption)
                .foregroundColor(.secondary)

            case .specify:
              Text("You specify a particular MAC address and LinkLiar sees to it that this Interface always has this address.")
                .font(.caption)
                .foregroundColor(.secondary)

              TextField("MAC Address",
                        value: specificAddress,
                        formatter: MACAddressFormatter(),
                        prompt: Text("e.g. aa:bb:cc:dd:ee:ff")
              )
              .disableAutocorrection(true)
              .border(.tertiary)
              .font(.system(.title3, design: .monospaced))
              .frame(width: 200)

            case .original:
              Text("LinkLiar ensures that this Interface always has its original hardware MAC address.")
                .font(.caption)
                .foregroundColor(.secondary)

            default:
              Text("Invalid")
          }

        }.padding([.bottom, .horizontal], 4)

      }
    }
  }
}

#Preview("Always Random") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "random"]]

  return PolicyActionView().environment(state).environment(interface)
}

#Preview("Specified MAC") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "specify", "address": "aa:bb:cc:dd:ee:ff"]]

  return PolicyActionView().environment(state).environment(interface)
}

#Preview("Original MAC") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "original"]]

  return PolicyActionView().environment(state).environment(interface)
}
