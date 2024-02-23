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
          Text(interface.name)
          Text(interface.bsd.name)
            .opacity(0.3)
            .font(.system(.body, design: .monospaced))
        }

        HStack(spacing: 8) {
          Button(action: {
            copy(interface.softMAC?.address ?? "??:??:??:??:??:??")
          }, label: {
            Text(interface.softMAC?.anonymous(state.config.general.isAnonymized) ?? "??:??:??:??:??:??")
              .font(.system(.body, design: .monospaced, weight: .light))
          }).buttonStyle(.plain)
        }

        Text(MACVendors.name(interface.softOUI))
          .font(.system(.footnote, design: .monospaced))
          .opacity(0.5)

        if !interface.hasOriginalMAC {
          HStack(spacing: 0) {
            Text("Originally ")
              .opacity(0.5)
              .font(.system(.footnote))
            Button(action: {
              copy(interface.hardMAC.address)
            }, label: {
              Text(interface.hardMAC.anonymous(state.config.general.isAnonymized))
                .font(.system(.footnote, design: .monospaced))
                .opacity(0.5)
            }).buttonStyle(.plain)
          }
        }
      }

      // Padding parity on the right side (invisible).
      Image("MenuIconLeaking").opacity(0)

    // Without this, only words (captions) are right-clickable. With it, you can click anywhere in this HStack.
    // See https://www.hackingwithswift.com/quick-start/swiftui/how-to-control-the-tappable-area-of-a-view-using-contentshape
    }.contentShape(Rectangle())
    .contextMenu {
      Button("Copy MAC address") { copy(interface.softMAC?.address ?? "??:??:??:??:??:??") }

      if state.config.arbiter(interface.hardMAC).action == .random && state.daemonRegistration == .enabled {
        Button("Randomize now") {
          Log.debug("Force randomization...")
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
  let interfaces = Interfaces.all(.sync)
  return InterfaceView(state: state, interface: interfaces.first!)
}
