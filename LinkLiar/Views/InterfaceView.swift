import SwiftUI

struct InterfaceView: View {
  @Bindable var interface: Interface
  
  var body: some View {
      
      // Separating Icons and text
      HStack(spacing: 8) {
        if interface.hasOriginalMAC {
          Image("MenuIconLeaking")
        } else {
          Image("MenuIconLeaking").opacity(0)
        }
        
        VStack(alignment: .leading) {
          HStack(spacing: 8) {
            Text(interface.displayName)
            Text(interface.BSDName).opacity(0.3)
          }
          
          HStack(spacing: 8) {
            Text(interface.softMAC.humanReadable).font(.system(.body, design: .monospaced))
          }
          
          if !interface.hasOriginalMAC {
            Text("Spoofing \(interface.hardMAC.humanReadable)").font(.system(.footnote, design: .monospaced)).opacity(0.5)
          }
        }
        Image("MenuIconLeaking").opacity(0)
        
        
        
      }
  }
}

//#Preview {
//  SettingsView()
//}
