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
import ServiceManagement

struct ApproveDaemonView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    if state.daemonRegistration == .requiresApproval {
      VStack {

        Image(systemName: "lock.shield")
          .font(.system(size: 40))
          .padding(.bottom, 4)

        Text("The LinkLiar background service\nwas installed and is waiting for\napproval.")
          .padding(.bottom, 4)

        Text("Please head over to the System\nSettings and activate it in the list\nof background services.")
          .padding(.bottom, 4)

        Button(action: SMAppService.openSystemSettingsLoginItems) {
          Text("Show Settings")
        }.padding(.bottom, 4)
          .buttonStyle(.borderedProminent)
      }

      Divider().padding(.vertical, 5)
    }
  }
}

#Preview {
  let state = LinkState()
  state.daemonRegistration = .requiresApproval
  return ApproveDaemonView().environment(state)
}
