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

struct PolicyDefaultOrCustomView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {

    // false means it is default
    // true means it has an action
    let value = Binding<Bool>(
      get: { state.config.policy(interface.hardMAC).action != nil },
      set: { value, _ in ConfigWriter.setInterfaceAction(interface: interface, action: (value ? .random : nil), state: state) })

    GroupBox {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 3) {
          Text("Customize Interface")
          if value.wrappedValue {
            Text("This Interface is managed using the custom rules below. If you turn this off, LinkLiar will do to this Interface whatever you defined as Interface default.")
              .font(.caption)
              .foregroundColor(.secondary)
          } else {
            Text("LinkLiar currently does to this Interface whatever you configured as a default for Interfaces. If you turn this on, you can define custom rules for this particular Interface.")
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
