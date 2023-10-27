import SwiftUI

struct SettingsView: View {
  var body: some View {
    TabView {
      
      VStack {
        Button(action: Controller.doAuthorize) {
          Text("Authorize...")
        }
      }.tabItem {
        Image(systemName: "checkmark.circle")
        Text("General")
      }
      
//      VStack {
//        Text("This is where the config file is located:")
//        Text(Paths.configFile)
//        Button(action: ConfigWriter.reset) {
//          Text("Reset Config file")
//        }
//        Text("Writable: \(ConfigWriter.isWritable ? "Yes" : "No")")
//      }.tabItem {
//        Image(systemName: "sun.min")
//        Text("Config file")
//      }
      
      
    }.frame(width: 500, height: 300)
    
  }
}

//#Preview {
//  SettingsView()
//}
