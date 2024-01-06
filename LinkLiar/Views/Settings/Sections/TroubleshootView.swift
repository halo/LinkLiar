// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreLocation
import CoreWLAN
import ServiceManagement
import SwiftUI

extension SettingsView {
  struct TroubleshootView: View {
    @Environment(LinkState.self) private var state

    @State private var latestGithubRelease = ""
    let locationManager = CLLocationManager()

    private func fetchLatestRelease() {
      URLSession.shared.dataTask(with: Paths.githubApiReleasesURL) { data, _, error in
           if let data {
             do {
               let json = try JSONSerialization.jsonObject(with: data, options: [])
               if let object = json as? [String: Any] {
                 latestGithubRelease = object["tag_name"] as? String ?? ""
               } else {
                 latestGithubRelease = ""
               }
             } catch let error as NSError {
               Log.error(error.localizedDescription)
             }
          }
      }.resume()
    }

    private func disassociateWifi() {
      CWWiFiClient.shared().interfaces()?.first?.disassociate()
    }

    var body: some View {
      VStack(alignment: .leading) {

        Text("General").font(.headline)

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

        Text("Background service").font(.headline).padding(.top)

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

        Text("Wi-Fi").font(.headline).padding(.top)

        ForEach(CWWiFiClient.shared().interfaces()!, id: \.self) { interface in
          GroupBox {
            HStack(alignment: .top) {
              Menu {
                Button(action: { disassociateWifi() }, label: {
                  Text("Disassociate")
                })

                Button(action: { LocationManager.instance.requestAlwaysAuthorization() }, label: {
                  Text("Request authorization")
                })
                Divider()
                Button(action: { NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!) }, label: {
                  Text("Show Location Settings")
                })
              } label: {
                if let BSDName = interface.interfaceName {
                  Text("SSID of \(BSDName)")

                } else {
                  Text("SSID...")
                }
              }.menuStyle(.borderlessButton).fixedSize()
              Spacer()

              if LocationManager.instance.authorizationStatus == .denied {
                  Text("L denied")
              } else if LocationManager.instance.authorizationStatus == .authorizedAlways {
                Text("L authorizedAlways")
              } else if LocationManager.instance.authorizationStatus == .notDetermined {
                Text("L notDetermined")

              }

              if let ssid = interface.ssid() {
                Text(ssid)
              } else {
                Text("(no SSID)")
              }

              if let bssid = interface.bssid() {
                Text(bssid)
              } else {
                Text("(no BSSID)")
              }

            }.padding(4)
          }
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
}

#Preview {
  let state = LinkState()
  state.allInterfaces = Interfaces.all(asyncSoftMac: false)

  return SettingsView.TroubleshootView().environment(state)
}
