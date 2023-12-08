// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct InterfacePrefixesView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  var body: some View {
    VStack(alignment: .leading) {
      VStack(alignment: .leading) {

        Text("""
             Whenever LinkLiar is assigning a random MAC address to this interface,
             you can choose which vendor prefixes should be used.
             """)
          .padding(4)

      }
    }
  }

}
