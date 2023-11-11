import SwiftUI

struct MenuView: View {
  @State var observer: NSKeyValueObservation?
  @Environment(LinkState.self) private var state
  
  @State var selectedItem: String = ""
  @State var items = ["One","Two"]
  @State var isHovering: Bool = false

  var body: some View {
    VStack {
      RegisterDaemonView().environment(state)
      ApproveDaemonView().environment(state)
      
      InterfacesView().environment(state)
      
      Divider().padding([.top, .bottom], 3)

      HStack() {
        SettingsLink {
//          Image(systemName: "gear").imageScale(.medium)
          Text("Settings")
        }.keyboardShortcut(",", modifiers: .command)
          .buttonStyle(.accessoryBar)
        
        Button("Quit") {
          Controller.wantsToQuit(state)
        }.keyboardShortcut("q")
          .buttonStyle(.accessoryBar)
      }
      
      ConfirmQuittingView().environment(state)

    }.padding(12).fixedSize()
      .onAppear {
        // See https://damian.fyi/swift/2022/12/29/detecting-when-a-swiftui-menubarextra-with-window-style-is-opened.html
        observer = NSApplication.shared.observe(\.keyWindow) { x, y in
          NotificationCenter.default.post(name: .menuBarAppeared, object: nil)
        }
      }
  }
}

#Preview("Standard") {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  return MenuView().environment(state)
}

#Preview("Daemon not registered") {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  state.daemonRegistration = .notRegistered
  return MenuView().environment(state)
}

#Preview("Daemon requires approval") {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  state.daemonRegistration = .requiresApproval
  return MenuView().environment(state)
}

#Preview("Wanting to quit") {
  let state = LinkState()
  state.interfaces = Interfaces.all(asyncSoftMac: false)
  state.wantsToQuit = true
  return MenuView().environment(state)
}
