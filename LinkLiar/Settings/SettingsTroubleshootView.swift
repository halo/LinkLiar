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

struct SettingsTroubleshootView: View {
  @Environment(LinkState.self) private var state

  @State private var latestGithubRelease = ""

  private func fetchLatestRelease() {
    URLSession.shared.dataTask(with: Paths.githubApiReleasesURL) { data, _, error in
         if let data = data {
           do {
             let json = try JSONSerialization.jsonObject(with: data, options: [])
             if let object = json as? [String: Any] {
               print("Yeeeeees")
               print(object)
               latestGithubRelease = object["tag_name"] as? String ?? ""
             } else {
               print("NOOOOOOOOOOOO")
               latestGithubRelease = ""
             }
           } catch let error as NSError {
             Log.error(error.localizedDescription)
           }
        }
      }.resume()
  }

  var body: some View {
    VStack {

      GroupBox {
        HStack(alignment: .top) {
          Menu {
            Button(action: { fetchLatestRelease() }) {
              Text("Check for updates")
            }
          } label: {
            Text("GUI Version")
          }.menuStyle(.borderlessButton).fixedSize()
          Spacer()
          if latestGithubRelease == state.version.formatted {
            Text("You have the latest version  ")
          } else if latestGithubRelease != "" {
            Text("\(latestGithubRelease) is the latest release  ")
          }
          Text(state.version.formatted)
          if latestGithubRelease == state.version.formatted {
            Image(systemName: "checkmark").foregroundColor(.green)
          } else if latestGithubRelease != "" {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.orange)
          }
        }.padding(4)
      }

      GroupBox {
        HStack {
          Menu {
            Button(action: { Controller.registerDaemon(state: state) }) {
              Text("Register Daemon")
            }
            Button(action: { Controller.unregisterDaemon(state: state) }) {
              Text("Unregister Daemon")
            }
            Divider()
            Button(action: SMAppService.openSystemSettingsLoginItems) {
              Text("Show Login Items")
            }

          } label: {
            Text("Daemon State")
          }.menuStyle(.borderlessButton).fixedSize()

          Spacer()

          Text(state.daemonRegistration.rawValue)
            .font(.system(.subheadline, design: .monospaced))
            .foregroundColor(.secondary)

          if state.daemonRegistration == .enabled {
            Image(systemName: "checkmark").foregroundColor(.green)
          } else if state.daemonRegistration == .requiresApproval {
            Image(systemName: "lock.fill").foregroundColor(.orange)
          } else {
            Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
          }
        }.padding(4)
      }

      Spacer()
    }.padding()
    //    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)

    //
    //    VStack {
    //      Text("Config file version: \(state.config.version ?? "?")")
    //      Text("GUI Version: \(state.version.formatted)")
    //
    //      Text("Daemon State: \(state.daemonRegistration.rawValue)")
    //      Text("Daemon Version: \(state.daemonVersion.formatted)")
    //      HStack {
    //        Button(action: { Controller.registerDaemon(state: state) }) {
    //          Text("Register Daemon")
    //        }
    //        Button(action: SMAppService.openSystemSettingsLoginItems) {
    //          Text("Show Login Items")
    //        }
    //        Button(action: { Controller.unregisterDaemon(state: state) }) {
    //          Text("Unregister Daemon")
    //        }
    //      }
    //
    //      Text("XPC State: \(state.xpcStatus.rawValue)")
    //      HStack {
    //        Button(action: { Controller.troubleshoot(state: state) }) {
    //          Image(systemName: "arrow.2.circlepath")
    //        }
    //      }

  }

}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)

  return SettingsTroubleshootView().environment(state)

}
