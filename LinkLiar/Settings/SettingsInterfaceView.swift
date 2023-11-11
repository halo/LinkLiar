import SwiftUI

struct SettingsInterfaceView: View {
  @Environment(LinkState.self) private var state
  
  @Binding var hardMAC: String?
  
  var body: some View {
    if let interface {
      VStack(alignment: .leading) {
        
        Text(interface.displayName)
          .font(.title2)
          .padding(.top)
        
        Text(interface.BSDName)
          .font(.system(.body, design: .monospaced))
          .opacity(0.5)
          .padding(.bottom)
        
        Form {
                  Section(header: Text("Notifications")) {
//                      Picker("Notify Me About", selection: $notifyMeAbout) {
//                          Text("Direct Messages").tag(NotifyMeAboutType.directMessages)
//                          Text("Mentions").tag(NotifyMeAboutType.mentions)
//                          Text("Anything").tag(NotifyMeAboutType.anything)
//                      }
//                      Toggle("Play notification sounds", isOn: $playNotificationSounds)
//                      Toggle("Send read receipts", isOn: $sendReadReceipts)
                  }
                  Section(header: Text("User Profiles")) {
//                      Picker("Profile Image Size", selection: $profileImageSize) {
//                          Text("Large").tag(ProfileImageSize.large)
//                          Text("Medium").tag(ProfileImageSize.medium)
//                          Text("Small").tag(ProfileImageSize.small)
//                      }
                  }
              }
        
                
        let oneBinding = Binding<Bool>(
                get: { return true },
                set: { _,_ in } )
        GroupBox {
          HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
              Text("Show in Menu Bar")
              Text("When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, When you disable this, ").font(.caption)
            }
            Spacer()
            Toggle(isOn: oneBinding) {}.toggleStyle(.switch).controlSize(.small)
          }.padding(4)
          
          Divider()

          HStack {
            Text("Manage MAC address")
            Spacer()
            Toggle(isOn: oneBinding) {}.toggleStyle(.switch).controlSize(.small)
          }.padding(4)

          Divider()

          HStack {
            Text("Behavior")
            Spacer()
            Menu {
                Button {
                    // do something
                } label: {
                    Text("Linear")
                    Image(systemName: "arrow.down.right.circle")
                }
                Button {
                    // do something
                } label: {
                    Text("Radial")
                    Image(systemName: "arrow.up.and.down.circle")
                }
            } label: {
                 Text("Styles")
                 Image(systemName: "tag.circle")
            }.menuStyle(.borderlessButton)
              
//            Picker {
//              
//            }
          }.padding(4)
          Divider()
          HStack {
            Text("Specify Address")
            Spacer()
          }.padding(4)

        }
        
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
      
    } else {
      Text("Could not find Interface \(hardMAC ?? "?")")
    }
    
    
  }
  
  private var interface: Interface? {
    state.interfaces.first(where: { $0.id == hardMAC })
  }
}

#Preview {
  struct Preview: View {
    @State var state: LinkState = LinkState()
    @State var hardMAC: String? = "" // Insert your Wi-Fi Hard MAC here
    
    init() {
      state.interfaces = Interfaces.all(asyncSoftMac: false)
      // FIXME: Why is this not working?
      hardMAC = state.interfaces.first!.id
    }
    
    var body: some View {
      return SettingsInterfaceView(hardMAC: $hardMAC).environment(state)
    }
  }
  
  return Preview()
}
