// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct VendorsView: View {
    @Environment(LinkState.self) private var state

    @State private var vendors = [Vendor]()

    var body: some View {
      VStack {
        Table(state.config.vendors.popularMarked) {

          TableColumn("On") { vendor in
            let isChosen = Binding<Bool>(
//              get: { vendor.isChosen },
              get: { state.config.vendors.chosenIDs.contains(where: { $0 == vendor.id }) },
              set: { value, _ in toggleVendor(value: value, vendor: vendor) })

            Toggle("", isOn: isChosen)

          }.width(20)

          TableColumn("Name", value: \.name)
            .width(340)

          TableColumn("Prefixes") { vendor in
            Text("\(vendor.prefixes.count)")
          }.width(50)
        }
      }.padding()
    }

    private func toggleVendor(value: Bool, vendor: Vendor) {
      if value {
        Config.Writer(state).addVendor(vendor)
      } else {
        Config.Writer(state).removeVendor(vendor)
      }

      // TODO: Why does the table not refresh unless I do this radical hack?
//      state.configDictionary = [:]
    }
  }
}

#Preview {
  let state = LinkState()

  return SettingsView.VendorsView().environment(state)
}
