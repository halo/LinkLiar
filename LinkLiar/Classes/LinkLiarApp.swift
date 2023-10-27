import SwiftUI

@main

struct LinkLiarApp: App {
  @State private var state = LinkState()

  var body: some Scene {
    MenuBarExtra("LinkLiar", image: menuBarIconName) {
      LinkMenu().environment(state)
    }
    
//    WindowGroup {
//      VStack {
//        Text(Controller.version)
//        Button(action: Controller.doAuthorize) {
//          Text("Authorize...")
//        }
//        Button(action: Controller.doUnAuthorize) {
//          Text("UnAuthorize...")
//        }
//        Button(action: Controller.install) {
//          Text("Install...")
//        }
//        Button(action: Controller.uninstall) {
//          Text("UnInstall...")
//        }
//      }
//    }
  }
  
  
  private var menuBarIconName: String {
    state.warnAboutLeakage ? "MenuIconLeaking" : "MenuIconProtected"
  }
}



struct LinkMenu: View {
  @Environment(LinkState.self) private var state
  
  var body: some View {
    Button("One") {
      state.warnAboutLeakage = true
    }
    Button("Two") {
      state.warnAboutLeakage = false
    }
    Divider()
  }
}
