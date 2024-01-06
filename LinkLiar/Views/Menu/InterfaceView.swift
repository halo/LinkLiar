// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct InterfaceView: View {
  @Bindable var state: LinkState
  @Bindable var interface: Interface

  var body: some View {
    // Separating Icons and text
    HStack(spacing: 8) {
      if interface.hasOriginalMAC {
        Image("MenuIconLeaking")
      } else {
        // Invisible placeholder in the same size as the leaking icon.
        Image("MenuIconLeaking").opacity(0)
      }

      VStack(alignment: .leading) {
        HStack(spacing: 8) {
          Text(interface.displayName)
          Text(interface.BSDName)
            .opacity(0.3)
            .font(.system(.body, design: .monospaced))
        }

        HStack(spacing: 8) {
          Button(action: {
            copy(interface.softMAC.humanReadable)
          }, label: {
            Text(interface.softMAC.humanReadable)
              .font(.system(.body, design: .monospaced, weight: .light))
          }).buttonStyle(.plain)
        }

        if !interface.hasOriginalMAC {
          HStack(spacing: 0) {
            Text("Originally ")
              .opacity(0.5)
              .font(.system(.footnote))
            Button(action: {
              copy(interface.hardMAC.humanReadable)
            }, label: {
              Text(interface.hardMAC.humanReadable)
              .font(.system(.footnote, design: .monospaced))
              .opacity(0.5)
            }).buttonStyle(.plain)
          }
        }
      }
      // Padding parity on the right side (invisible).
      Image("MenuIconLeaking").opacity(0)

    }.contextMenu {
      Button("Copy MAC address") { copy(interface.softMAC.humanReadable) }

      if state.config.arbiter(interface.hardMAC).action == .random && state.daemonRegistration == .enabled {
        Button("Randomize now") {
          Config.Writer(state).resetExceptionAddress(interface: interface)
        }
      }
    }
  }

  private func copy(_ content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
  }
}

#Preview {
  let state = LinkState()
  let interfaces = Interfaces.all(asyncSoftMac: false)
  return InterfaceView(state: state, interface: interfaces.first!)
}
