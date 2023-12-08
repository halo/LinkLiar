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
              // FIXME: This doesn't reliably work when pressing this button repeatedly.
              copiedHardMAC = 0
            })
          }) {
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
          }.buttonStyle(.plain)

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
