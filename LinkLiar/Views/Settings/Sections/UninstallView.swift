// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct UninstallView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {
        VStack(alignment: .center) {
          Image(systemName: "trash.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .padding(.bottom, 3)
          Text("Uninstall LinkLiar").bold()
        }.padding()

        if state.daemonRegistration == .notRegistered || state.daemonRegistration == .notFound {
          HStack {
            Text("""
             There is no background service installed.

             You can delete LinkLiar.app to uninstall.
             """)
            Spacer()
          }.padding(.bottom)

        } else {

          VStack {
            HStack {
              Text("""
               You can press this button \
               to deactivate all background activity immediately:
               """)
              Spacer()
            }.padding(.bottom)

            Button(action: { Controller.unregisterDaemon(state: state) }) {
              Text("Unregister Background Service")
            }.padding(.bottom)

            HStack {
              Text("Then delete")
              Text("LinkLiar.app").monospaced().bold()
              Spacer()
            }.padding(.bottom)

          }
        }

        if state.daemonRegistration != .notFound {
          HStack {
            Text("""
             Notice that LinkLiar may still appear in your "Allow in the Background" \
             list of apps.
             This is intended behavior by Apple. If it really bothers you, \
             there is a command called `sfltool resetbtm`  which you can investigate \
             to solve the problem.
             """)
            Spacer()
          }.padding(.bottom)
        }

      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.UninstallView().environment(state)
}
