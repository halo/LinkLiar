// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct InterfaceView: View {
  @Bindable var interface: Interface

  @State var hoversHardMAC = false
  @State var copiedHardMAC = 0.0
  @State var hoversSoftMAC = false

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
              .onHover { hovering in
                hoversSoftMAC = hovering
              }
          }).buttonStyle(.plain)
        }

        if !interface.hasOriginalMAC {
          HStack(spacing: 0) {
            Text("Originally ")
              .opacity(0.5)
              .font(.system(.footnote))
            Text(interface.hardMAC.humanReadable)
              .font(.system(.footnote, design: .monospaced))
              .textSelection(.enabled)
              .opacity(0.5)
          }
        }
      }
      // Padding parity on the right side (invisible).
      Image("MenuIconLeaking").opacity(0)
    }.contextMenu {
      Button("Delete", role: .destructive) {  }
      /*@START_MENU_TOKEN@*/Text("Menu Item 2")/*@END_MENU_TOKEN@*/
      /*@START_MENU_TOKEN@*/Text("Menu Item 3")/*@END_MENU_TOKEN@*/
    }
  }

  private var now: Double {
    Date().timeIntervalSince1970
  }

  private var recentlyCopied: Bool {
    copiedHardMAC > now - 2
  }

  private func copy(_ content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
  }
}

#Preview {
  let interfaces = Interfaces.all(asyncSoftMac: false)
  return InterfaceView(interface: interfaces.first!)
}
