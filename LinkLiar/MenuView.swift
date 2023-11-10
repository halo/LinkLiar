import SwiftUI

struct MenuView: View {
  @State var observer: NSKeyValueObservation?
  @Environment(LinkState.self) private var state
  
  var body: some View {
    VStack {
      RegisterDaemonView().environment(state)
      ApproveDaemonView().environment(state)
      InterfacesView().environment(state)
      
      Spacer().padding(.bottom, 1)
      Divider()
      Spacer().padding(.bottom, 1)

      HStack() {
        SettingsLink {
          Text("Settings")
        }.keyboardShortcut(",", modifiers: .command)
          .buttonStyle(.accessoryBar)
        
        Button("Quit") {
          NSApplication.shared.terminate(nil)
        }.keyboardShortcut("q")
          .buttonStyle(.accessoryBar)
      }.padding(.bottom, 15)
      
    }.fixedSize()
      .onAppear {
        // See https://damian.fyi/swift/2022/12/29/detecting-when-a-swiftui-menubarextra-with-window-style-is-opened.html
        observer = NSApplication.shared.observe(\.keyWindow) { x, y in
          NotificationCenter.default.post(name: .menuBarAppeared, object: nil)
        }
      }
  }
}

#Preview {
  let state = LinkState()
  Controller.queryInterfaces(state: state)
  return MenuView().environment(state)
}
