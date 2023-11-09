import SwiftUI

struct SettingsView: View {
  @Environment(LinkState.self) private var state

  var body: some View {
    SettingsPoliciesView().environment(state)
//    SettingsTroubleshootView().environment(state)
//    TabView {
//      
//      
//
//
//      
////      VStack {
////        Text("This is where the config file is located:")
////        Text(Paths.configFile)
////        Button(action: ConfigWriter.reset) {
////          Text("Reset Config file")
////        }
////        Text("Writable: \(ConfigWriter.isWritable ? "Yes" : "No")")
////      }.tabItem {
////        Image(systemName: "sun.min")
////        Text("Config file")
////      }
//      
//      
//    }.frame(width: 500, height: 300)
    
  }
}
