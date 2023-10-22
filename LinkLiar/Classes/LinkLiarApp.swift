import SwiftUI

@main

struct LinkLiarApp: App {
  var body: some Scene {
    WindowGroup {
      VStack {
        Button(action: Controller.doAuthorize) {
          Text("Authorize...")
        }
      }
    }
  }
}
