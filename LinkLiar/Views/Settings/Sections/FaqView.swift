// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

extension SettingsView {
  struct FaqView: View {
    @Environment(LinkState.self) private var state

    var body: some View {
      ScrollView {
        VStack(alignment: .center) {
          Image(systemName: "book.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 60, height: 60)
            .padding(.bottom, 3)
          Text("Frequently Asked Questions").bold()
        }.padding()

        GroupBox("LinkLiar does not provide anonymity.", content: {
          HStack {
            Text("""
               Even with a modified MAC address, the negotiation packets \
               between your network interface and an access point reveal what \
               operating system you use. Not to mention, that your traffic may be inspected to de-anonymize you.
               """)
            Spacer()
          }
        }).padding(.bottom)

        GroupBox("LinkLiar does not prevent MAC address leaks.", content: {
          HStack {
            Text("""
               You original hardware MAC address will be revealed when you cold boot your computer and Wi-Fi \
               is turned on. However, MAC address modifications do persist when sleeping and waking your computer.
               """)
            Spacer()
          }
        }).padding(.bottom)

        GroupBox("Changing your MAC address makes you loose your connection.", content: {
          HStack {
            Text("""
                 The MAC address of an interface cannot be modified while connected to a Wi-Fi network. \
                 That's why LinkLiar will disassociate from any connected network before attempting to modify the MAC address.
                 """)
            Spacer()
          }
        }).padding(.bottom)

        GroupBox("Wi-Fi needs to be on for MAC modification.", content: {
          HStack {
            Text("""
                 "When your Wi-Fi (aka Airport) is turned off, you cannot change its MAC address. \
                 You might need to turn it on first.
                 """)
            Spacer()
          }
        }).padding(.bottom)

      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()
  return SettingsView.FaqView().environment(state).frame(width: 500)
}
