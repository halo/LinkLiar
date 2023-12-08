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
        // Placeholder in the same size as the icon.
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
            copiedHardMAC = now
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
              // This doesn't reliably work when pressing this button repeatedly, but I can live with that.
              copiedHardMAC = 0
            })
          }, label: {
            Text(interface.softMAC.humanReadable)
              .font(.system(.body, design: .monospaced, weight: .light))
              .onHover { hovering in
                hoversSoftMAC = hovering
              }

//            if hoversSoftMAC || recentlyCopied {
//              let hoverImageName = recentlyCopied ? "checkmark" : "doc.on.doc.fill"
//              Image(systemName: hoverImageName)
//                .imageScale(.small)
//                .opacity(0.5)
//            } else {
//              let hoverImageName = recentlyCopied ? "checkmark" : "doc.on.doc.fill"
//              Image(systemName: hoverImageName)
//                .imageScale(.small)
//                .opacity(0)
//            }
          }).buttonStyle(.plain)

          //            Text(interface.softMAC.humanReadable)
          //              .font(.system(.body, design: .monospaced))
          //              .onTapGesture(count: 2) {
          //                let pasteboard = NSPasteboard.general
          //                pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
          //                pasteboard.setString("Good Morning", forType: NSPasteboard.PasteboardType.string)
          //              }
        }

        if !interface.hasOriginalMAC {
          Text("Originally \(interface.hardMAC.humanReadable)")
            .font(.system(.footnote, design: .monospaced))
            .textSelection(.enabled)
            .opacity(0.5)
        }
      }
      // Padding parity on the right side.
      Image("MenuIconLeaking").opacity(0)

    }
  }

  private var now: Double {
    return Date().timeIntervalSince1970
  }

  private var recentlyCopied: Bool {
    return copiedHardMAC > now - 2
  }

  private func copy(_ content: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
    pasteboard.setString(content, forType: NSPasteboard.PasteboardType.string)
  }
}

#Preview {
  let interfaces = Interfaces.all(asyncSoftMac: true)
  return InterfaceView(interface: interfaces.first!)
}
