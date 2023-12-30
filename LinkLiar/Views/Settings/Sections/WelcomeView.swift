// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct WelcomeView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {

        VStack(alignment: .center) {
          Image(systemName: "hands.and.sparkles.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .padding(.bottom, 3)
          Text("Welcome to the LinkLiar Beginner's Guide!")
        }.padding()

        VStack(alignment: .leading) {
          Text("You know how mobile phones have unique phone numbers ") +
          Text("so that they can talk to each other?")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "candybarphone")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 20)
                Text("Hello 55522? This is 55511!").italic()
              }
              Spacer().frame(width: 40)
              VStack {
                Image(systemName: "candybarphone")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 20)
                Text("Ah, there you are!").italic()
              }
              Spacer()
            }.padding(8)
          }.padding(.bottom)

          Text("Computers don't have phone numbers, but IP addresses. ") +
          Text("Usually the Wi-Fi hands out an IP address to every new computer.")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "laptopcomputer")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 40)
                Text("Hello! I'm new here.").italic()
              }
              Spacer().frame(width: 40)
              VStack {
                Image(systemName: "wifi.router.fill")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 37)
                Text("OK, your IP is 192.0.2.1").italic()
              }
              Spacer()
            }.padding(5)
          }.padding(.bottom)

          Text("Now, imagine a coffeeshop with many laptops and phones, all of them want to join the Wi-Fi. ") +
            Text("How would they communicate over the air, if they don't have received IP addresses yet?")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "laptopcomputer")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 35)
                Text("Hi! I'm here!").italic()
              }
              Spacer().frame(width: 40)
              VStack {
                Image(systemName: "laptopcomputer")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 37)
                Text("So am I!").italic()
              }
              Spacer().frame(width: 40)
              VStack {
                Image(systemName: "wifi.router.fill")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 37)
                Text("Wait, who's talking?").italic()
              }
              Spacer()
            }.padding(5)
          }.padding(.bottom)

          Text("To solve this problem, every device has been assigned a unique MAC address ") +
            Text("(by the way, this has nothing to do with the word \"Macintosh\"). ") +
            Text("This address was given to the device in the factory, when the device was built. ") +
            Text("It is used to establish first contact over the air.")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Spacer()
                HStack {
                  VStack {
                    Image(systemName: "laptopcomputer")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 44)
                    Text("Hi! My MAC is").italic()
                    Text("aa:aa:aa:aa:aa:aa!").italic()
                  }
                  Spacer().frame(width: 40)
                  VStack {
                    Image(systemName: "laptopcomputer")
                      .resizable()
                      .aspectRatio(contentMode: .fill)
                      .frame(width: 44)
                    Text("And I have").italic()
                    Text("bb:bb:bb:bb:bb:bb!").italic()
                  }
                }
                Spacer(minLength: 20)
                VStack {
                  Image(systemName: "wifi.router.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40)
                  Text("Greetings, my MAC is cc:cc:cc:cc:cc:cc.").italic()
                  Text("So, aa:aa:aa:aa:aa:aa, you get IP 192.0.2.1.").italic()
                  Text("And bb:bb:bb:bb:bb:bb you get IP 192.0.2.2. ").italic()
                }
                Spacer()
              }.padding(5)
                Spacer()
            }
          }.padding(.bottom)

          Text("The MAC address is unique to every device, so everyone could easily find out ") +
            Text("who's in the coffeeshop at any given time! ") +
            Text("To alleviate this, Apple iPhones started to lie abour their MAC address.")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "iphone")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 22)
                Text("Hi! My MAC is ").italic() +
                  Text("dd:dd:dd:dd:dd:dd...").italic()
                Text("uh... I mean ee:ee:ee:ee:ee:ee, really!").italic()
              }
              Spacer()
            }.padding(5)
          }.padding(.bottom)

          Text("So, this is a good protection for iPhones. Unfortunately, your MacBook never lies, ") +
            Text("but always announces its true MAC address. ") +
            Text("Luckily, you can change what MAC address your laptop announces!")

          Spacer(minLength: 10)

          Text("Every laptop has a built-in function to do this. But it's not intuitive to use. ") +
          Text("LinkLiar is a small tool to help you change your MAC address.")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "laptopcomputer")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 40)
                Text("Hi! My MAC is... ").italic()
                  Text("ff:ff:ff:ff:ff:ff... ").italic() +
                Text("you can believe me!").italic()
              }
              Spacer()
            }.padding(5)
          }.padding(.bottom)

          Text("Incidentally, the MAC address is often used to grant permission for using a public Wi-Fi. ")

          GroupBox {
            HStack {
              Spacer()
              VStack {
                Image(systemName: "laptopcomputer")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 40)
                Text("Hello hotel Wi-Fi!").italic()
                Text("My MAC is aa:aa:aa:aa:aa:aa").italic()
              }
              Spacer().frame(width: 40)
              VStack {
                Image(systemName: "wifi.router.fill")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 37)
                Text("Hah, I know who you are!").italic()
                Text("You may use my Internet for 1 hour.").italic()
              }
              Spacer()
            }.padding(5)
          }.padding(.bottom)

          Text("You can see that there are good reasons to be able to change your MAC address. ") +
            Text("The most important one is doubtlessly to achieve the same level of privacy ") +
            Text("that your phone already has. ")

          Spacer()
        }
      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.WelcomeView().environment(state).frame(width: 515)
}
