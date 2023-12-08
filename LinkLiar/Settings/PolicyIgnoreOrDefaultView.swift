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

struct PolicyIgnoreOrDefaultView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {

    // false means it is ignored
    // true means it is anything else
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != .ignore },
      set: { value, _ in ConfigWriter.setInterfaceActionIgnoredness(interface: interface, isIgnored: !value, state: state) })

    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Manage MAC address")
          if value.wrappedValue {
            Text("LinkLiar may change the MAC address of this interface. If you turn this off, LinkLiar will never change this Interface and not warn you if it has its original MAC address.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("This Interface is currently being ignored by LinkLiar. If you turn this on, LinkLiar will start managing its MAC address and warn you whenever it uses its original MAC address.")
              .font(.caption)
              .foregroundColor(.secondary)
          }
        }
        Spacer()

        Toggle(isOn: value) {}
          .toggleStyle(.switch)
          .controlSize(.small)

      }.padding(4)
    }
  }
}

#Preview {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!

  return PolicyDefaultOrCustomView().environment(state)
                                            .environment(interface)
}
