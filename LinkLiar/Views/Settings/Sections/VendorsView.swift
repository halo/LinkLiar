// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct VendorsView: View {
    @Environment(LinkState.self) private var state

    @State private var allVendors = PopularVendors.all
    @State private var selectedVendors = Set<Vendor.ID>()
    @State private var sortOrder = [KeyPathComparator(\Vendor.name)]

    var body: some View {
//      selectedVendors = state.config.vendors.chosenPopular.map { $0.id }

//      let chosenVendors: [String] = state.config.vendors.chosenPopular.map { $0.id }

      VStack {
        Text("Vendors...")

        Table(allVendors, selection: $selectedVendors, sortOrder: $sortOrder) {
//
////          let chosen = Binding<Bool>(
////            get: {
////              chosenVendors.contains(where: { $0.id == \.id })
////            },
////            set: { _, _ in }
////         )
//
//          TableColumn("") { _ in
//            Toggle(isOn: \.isChosen)
//
//          }.width(20)

          TableColumn("Name", value: \.name)
            .width(360)
          TableColumn("Prefixes") { vendor in
            Text("\(vendor.prefixes.count)")
          }.width(50)

        }.onChange(of: sortOrder) {
          allVendors.sort(using: sortOrder)

        }.onChange(of: selectedVendors) {
          let vendorIds = selectedVendors.map { String($0) }
          let newVendors = PopularVendors.find(vendorIds)
          Config.Writer(state).setVendors(vendors: newVendors)
        }
      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()

  return SettingsView.VendorsView().environment(state)
}
