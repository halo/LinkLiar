import SwiftUI

struct MenuView: View {
  @State var observer: NSKeyValueObservation?
  @Environment(LinkState.self) private var state
  
  var body: some View {
    VStack {
      
      // Container for Interfaces
      VStack(alignment: .leading, spacing: 12) {
        ForEach(state.interfaces) { interface in
          // One Interface
          InterfaceView(interface: interface)
        }
      }.padding()
      
      
      
      //    Text("Welcome to LinkLiar.")
      //    Text("If you're new to this app, I recommend the beginners guide")
      //
      //    Button("One One One One One One One One One One One One One \nTwo One One One One One One One One One One One One One One One One One One ") {
      //      state.warnAboutLeakage = true
      //    }
      //    Button("Two") {
      //      state.warnAboutLeakage = false
      //    }
      //    Divider()
      
      SettingsLink{
        Text("Settings...")
      }.keyboardShortcut(",", modifiers: .command)
          Divider()
      //
      //
      Button("Quit") {
        
        NSApplication.shared.terminate(nil)
        
      }.keyboardShortcut("q")
    }.fixedSize().onAppear {
      observer = NSApplication.shared.observe(\.keyWindow) { x, y in
          print("Is visible: \(NSApplication.shared.keyWindow != nil)")
      }
  }
  }
}

//#Preview {
//  SettingsView()
//}
