// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct VendorsView: View {
    @Environment(LinkState.self) private var state

    @State private var selectedVendors = Set<Vendor.ID>()
    @State private var sortOrder = [KeyPathComparator(\Vendor.name)]
    @State private var vendors = PopularVendors.all

    var body: some View {
      let value = Binding<Bool>(
        get: { true },
        set: { _, _ in }
      )

      VStack {
        Text("Vendors...")

        Table(vendors, selection: $selectedVendors, sortOrder: $sortOrder) {

          TableColumn("") { _ in
            Toggle(isOn: value) {}
          }.width(20)

          TableColumn("Name", value: \.name)
            .width(380)
          TableColumn("Prefixes") { vendor in
            Text("\(vendor.prefixes.count)")
          }.width(50)
        }.onChange(of: sortOrder) {
          vendors.sort(using: $0)
        }
      }.padding()
    }
  }
}

#Preview {
  let state = LinkState()

  return SettingsView.VendorsView().environment(state)
}
