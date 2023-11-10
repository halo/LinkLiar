import SwiftUI

struct InterfaceView: View {
  @Bindable var interface: Interface
  
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
            Text(interface.BSDName).opacity(0.3).font(.system(.body, design: .monospaced))
          }
          
          HStack(spacing: 8) {
            Text(interface.softMAC.humanReadable).font(.system(.body, design: .monospaced))
          }
          
          if !interface.hasOriginalMAC {
            Text("Spoofing \(interface.hardMAC.humanReadable)").font(.system(.footnote, design: .monospaced)).opacity(0.5)
          }
        }
        // Padding parity on the right side.
        Image("MenuIconLeaking").opacity(0)
        
        
        
      }
  }
}

#Preview {
  let interfaces = Interfaces.all(asyncSoftMac: true)
  return InterfaceView(interface: interfaces.first!)
}
