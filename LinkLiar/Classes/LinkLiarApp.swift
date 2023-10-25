import SwiftUI

@main

struct LinkLiarApp: App {
  var body: some Scene {
    WindowGroup {
      VStack {
        Button(action: Controller.doAuthorize) {
          Text("Authorize...")
        }
        Button(action: Controller.doUnAuthorize) {
          Text("UnAuthorize...")
        }
        Button(action: Controller.install) {
          Text("Install...")
        }
        Button(action: Controller.uninstall) {
          Text("UnInstall...")
        }
      }
    }
  }
}
