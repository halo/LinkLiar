// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct DiagnoseInterfaceView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {
    VStack(alignment: .leading) {
      Text("Diagnose...")
        .padding(4)
    }
  }
}

//
// #Preview("Always Random") {
//  let state = LinkState()
//  let interface = Interfaces.all(.sync).first!
//  state.configDictionary = ["ssids:\(interface.hardMAC.formatted)":
//                              ["Free Wifi": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "dd:dd:dd:dd:dd:dd"]]
//
//  return AccessPointsView().environment(state).environment(interface)
// }

// #Preview("Specified MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(.sync).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "specify", "address": "aa:bb:cc:dd:ee:ff"]]
//
//  return AccessPointView().environment(state).environment(interface)
// }
//
//
// #Preview("Original MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(.sync).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "original"]]
//
//  return AccessPointView().environment(state).environment(interface)
// }
//
