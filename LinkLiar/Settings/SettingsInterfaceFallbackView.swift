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

struct SettingsInterfaceFallbackView: View {
  @Environment(LinkState.self) private var state

  var body: some View {

    let actionValue = Binding<Interface.Action?>(
      get: { state.config.fallbackPolicy.action },
      set: { value, _ in ConfigWriter.setFallbackInterfaceAction(action: value, state: state) })

    VStack(alignment: .leading) {

      Text("Default Interface Settings")
        .font(.title2)
        .padding(.top)

      GroupBox {
        VStack(alignment: .leading) {

          HStack(alignment: .top) {
            Menu {
              Button(action: { ConfigWriter.setFallbackInterfaceAction(action: .random, state: state) }) {
                Text("Always Keep Random")
              }
              Button(action: { ConfigWriter.setFallbackInterfaceAction(action: .original, state: state) }) {
                Text("Keep Original MAC Address")
              }
              Button(action: { ConfigWriter.setFallbackInterfaceAction(action: nil, state: state) }) {
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
