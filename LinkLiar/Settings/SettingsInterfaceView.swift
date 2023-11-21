import SwiftUI

struct SettingsInterfaceView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface
  
  @State private var selectedTab = Tab.macaddress

  var body: some View {
    VStack {

      // --------
      // Headline
      // --------
      
      SettingsInterfaceHeadlineView().environment(state).environment(interface)
      
      switch state.config.policy(interface.hardMAC).action {
          
        case .hide:
          VStack {
            Spacer()
            HStack {
              Spacer()
                Text("This Interface is hidden from the menu bar\nand LinkLiar never changes its MAC address.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
              Spacer()
            }
            Spacer()
          }

        default:
          TabView {
            VStack {
              if (state.config.policy(interface.hardMAC).action != .hide) {
                PolicyIgnoreOrDefaultView().environment(state).environment(interface)
                
                if ((state.config.policy(interface.hardMAC).action) != .ignore) {
                  PolicyDefaultOrCustomView().environment(state).environment(interface)
                  
                  if ((state.config.policy(interface.hardMAC).action) != nil) {
                    
                    PolicyActionView().environment(state)
                      .environment(interface)
                    
                  }
                }
                
              }
              Spacer()
            }
                  .tabItem {
                      Text("MAC Address")
                  }.padding()
            
            if interface.isWifi {
              Text("Access Point")
                  .tabItem {
                      Text("Access Point")
                  }
          }
          }
//          Picker("What now?", selection: $selectedTab) {
//               Text("MAC Address").tag(Tab.macaddress)
//               Text("Access Points").tag(Tab.accesspoint)
//         }
////          .pickerStyle(.segmented)
//          .padding(0)
//          .background(.red)
      }
      
//      switch $selectedTab.wrappedValue {
//          
//        case .macaddress:
//
//        case .accesspoint:
//          Text("Access Point...")
//      }

      
      //        Form {
      //                  Section(header: Text("Notifications")) {
      ////                      Picker("Notify Me About", selection: $notifyMeAbout) {
      ////                          Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
      ////                          Text("Mentions").tag(NotifyMeAboutType.mentions)
      ////                          Text("Anything").tag(NotifyMeAboutType.anything)
      ////                      }
      ////                      Toggle("Play notification sounds", isOn: $playNotificationSounds)
      ////                      Toggle("Send read receipts", isOn: $sendReadReceipts)
      //                  }
      //                  Section(header: Text("User Profiles")) {
      ////                      Picker("Profile Image Size", selection: $profileImageSize) {
      ////                          Text("Large").tag(ProfileImageSize.large)
      ////                          Text("Medium").tag(ProfileImageSize.medium)
      ////                          Text("Small").tag(ProfileImageSize.small)
      ////                      }
      //                  }
      //              }
      //
      //
      //          Divider()
      //
      //          HStack {
      //            Text("Manage MAC address")
      //            Spacer()
      //            Toggle(isOn: oneBinding) {}.toggleStyle(.switch).controlSize(.small)
      //          }.padding(4)
      
      //          Divider()
      //
      //          HStack {
      //            Text("Behavior")
      //            Spacer()
      //            Menu {
      //                Button {
      //                    // do something
      //                } label: {
      //                    Text("Linear")
      //                    Image(systemName: "arrow.down.right.circle")
      //                }
      //                Button {
      //                    // do something
      //                } label: {
      //                    Text("Radial")
      //                    Image(systemName: "arrow.up.and.down.circle")
      //                }
      //            } label: {
      //                 Text("Styles")
      //                 Image(systemName: "tag.circle")
      //            }.menuStyle(.borderlessButton)
      //
      ////            Picker {
      ////
      ////            }
      //          }.padding(4)
      //          Divider()
      //          HStack {
      //            Text("Specify Address")
      //            Spacer()
      //          }.padding(4)
      
      //        }
      
      //        Picker {
      //          Button(action: {}) {
      //            Label("Create a file", systemImage: "doc")
      //          }
      //
      //          Button(action: {}) {
      //            Label("Create a folder", systemImage: "folder")
      //          }
      //          Menu("Copy") {
      //                 Button("Copy", action: {})
      //                 Button("Copy Formatted", action: {})
      //                 Button("Copy Library Path", action: {})
      //             }
      //        }
      //      label: {
      //        Label("Choose behavior", systemImage: "arcade.stick.console")
      //      }
      
      //        List {
      //          SettingsInterfaceActionView(interface: interface, action: Interface.Action.ignore).environment(state)
      //          SettingsInterfaceActionView(interface: interface, action: Interface.Action.random).environment(state)
      //          SettingsInterfaceActionView(interface: interface, action: Interface.Action.specify).environment(state)
      //        }.listStyle(.bordered)
      //        GroupBox(label:
      //                  Label("Default", systemImage: "wand.and.stars").font(.headline)
      //        ) {
      //          VStack(alignment: .leading) {
      //            Text("Lorem Ipsum Wow this is good")
      //          }
      //        }.padding(.bottom)
      //
      //        GroupBox(label:
      //                  Label("Do Nothing", systemImage: "bed.double.fill").font(.headline)
      //        ) {
      //          VStack(alignment: .leading) {
      //            Text("Lorem Ipsum Wow this is good")
      //          }
      //
      //        }
      
      
      //
      //        GroupBox {
      //          Text("Random")
      //        }.background(.red).frame(maxWidth: .infinity)
      //
      //        GroupBox {
      //          Text("Ignore")
      //        }
      //
      //        GroupBox {
      //          Text("Hide")
      //        }
      Spacer()
    }.padding()
    //      .background(.green)
    
    //    } else {
    //      Text("Could not find Interface \(hardMAC ?? "?")")
    //    }
    
    //    } else {
    //      Text("Interface removed.")
    //    }
  }
  
  //  private var loadInterface: Interface? {
  //    interface = state.interfaces.first(where: { $0.id == hardMAC })!
  //  }
}


extension SettingsInterfaceView {
  enum Tab: Int {
    case macaddress = 1
    case accesspoint = 2
  }
}

#Preview("Hidden") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "hide"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}

#Preview("Ignored WiFi") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).first!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "ignore"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}

#Preview("Ignored Cable") {
  let state = LinkState()
  let interface = Interfaces.all(asyncSoftMac: false).last!
  state.configDictionary = [interface.hardMAC.formatted: ["action": "ignore"]]

  return SettingsInterfaceView().environment(state).environment(interface)
}
