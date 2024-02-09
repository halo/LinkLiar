// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import ServiceManagement
import SwiftUI

extension SettingsView {
  struct VendorsView: View {
    @Environment(LinkState.self) private var state

    @State private var selectedVendors = Set<Vendor.ID>()

    var body: some View {
      VStack {
        Text("""
             When LinkLiar is supposed to randomize the MAC address of an Interface, \
             you can tell it here from which vendors it should pick a prefix.
             """) // .multilineTextAlignment(.leading)

        Table(state.config.vendors.popular, selection: $selectedVendors) {

          TableColumn("On") { vendor in
            let isChosen = Binding<Bool>(
              get: { state.config.vendors.isChosen(vendor) },
              set: { value, _ in toggleVendor(value: value, vendor: vendor) })

            Toggle("", isOn: isChosen)
          }.width(20)

          TableColumn("Name", value: \.name)
            .width(340)

          TableColumn("Prefixes") { vendor in
            Text("\(vendor.prefixCount)")
          }.width(50)
        }
      }.padding().onAppear {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
          if Int(event.keyCode) == CGKeyCode.kVKSpace {
            toggleSelectedVendors()
          }
          return event // No need to modify or otherwise intercept the received event.
        }
      }
    }

    private func toggleVendor(value: Bool, vendor: Vendor) {
      if CGKeyCode.optionKeyPressed {
        if value {
          Config.Writer(state).addAllVendors()
        } else {
          Config.Writer(state).removeAllVendors()
        }
        return
      }

      if value {
        Config.Writer(state).addVendor(vendor)
      } else {
        Config.Writer(state).removeVendor(vendor)
      }
    }

    private func toggleSelectedVendors() {
      let vendors = selectedVendors.compactMap { PopularVendors.find($0) }
      for vendor in vendors {
        if state.config.vendors.isChosen(vendor) {
          Config.Writer(state).removeVendor(vendor)
        } else {
          Config.Writer(state).addVendor(vendor)
        }
      }
    }
  }
}

#Preview {
   let state = LinkState()

  return SettingsView.VendorsView().environment(state)
}
