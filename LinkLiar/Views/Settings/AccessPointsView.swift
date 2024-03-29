// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import SwiftUI

struct AccessPointsView: View {
  @Environment(LinkState.self) private var state
  @Environment(Interface.self) private var interface

  @State private var selection: Config.AccessPointPolicy.ID?
  @State private var isAddPopoverPresented = false
  @State private var newSsid: String = ""
  @State private var newMAC: String = ""

  var body: some View {
    VStack(alignment: .leading) {
      Text("""
        When LinkLiar detects that you are connected to a Wi-Fi Access Point
        with a certain name (SSID), you can specify a MAC address that LinkLiar
        should assign to this interface. This overrides custom MAC settings for this Interface.
      """)
      .padding(4)

      Table(state.config.policy(interface.hardMAC).accessPoints, selection: $selection) {
        TableColumn("SSID", value: \.ssid.name)
          .width(250)
        TableColumn("MAC") { accessPointPolicy in
          Text(accessPointPolicy.softMAC.address)
            .font(.system(.body, design: .monospaced, weight: .light))
        }.width(150)
      }.contextMenu(forSelectionType: Config.AccessPointPolicy.ID.self) { _ in
        Button("Delete", role: .destructive) { removeSsid() }
      }
      HStack {
        Button(action: showAddAccessPointPopover) {
          Image(systemName: "plus")
        }.padding(10)
          .controlSize(.extraLarge)
          .buttonStyle(.borderless)
          .popover(isPresented: $isAddPopoverPresented) {
            HStack {
              TextField("WiFi Name",
                        text: $newSsid,
                        prompt: Text("e.g. The Coffee Shop")
              )
              .disableAutocorrection(true)
              .border(.tertiary)
              .font(.system(.title3))
              .frame(width: 250)
              TextField("MAC Address",
                        value: $newMAC,
                        formatter: MACAddressFormatter(),
                        prompt: Text("e.g. aa:bb:cc:dd:ee:ff")
              )
              .disableAutocorrection(true)
              .border(.tertiary)
              .font(.system(.title3, design: .monospaced))
              .frame(width: 250)
              Button(action: { addSsid() }, label: {
                Text("Add")
              })
            }.padding()
          }
          .presentationCompactAdaptation(.popover)

        Button(action: removeSsid) {
          Image(systemName: "minus")
        }.padding(.vertical, 10)
          .controlSize(.extraLarge)
          .buttonStyle(.borderless)
      }
    }
  }

  private func showAddAccessPointPopover() {
    isAddPopoverPresented = true
  }

  private func addSsid() {
    Log.debug("Adding SSID to Interface \(interface.hardMAC.address)")
    Config.Writer(state).addInterfaceSsid(interface: interface, ssid: newSsid, address: newMAC)
  }

  private func removeSsid() {
    guard let accessPointPolicy = state.config.policy(interface.hardMAC).accessPoints
      .first(where: { $0.id == selection }) else {
      Log.debug("SSID definition not found")
      return
    }
    Log.debug("Removing `\(accessPointPolicy.ssid)` from Interface \(interface.hardMAC.address)")
    Config.Writer(state).removeInterfaceSsid(interface: interface, ssid: accessPointPolicy.ssid.name)
  }
}

#Preview("Always Random") {
  let state = LinkState()
  let interface = Interfaces.all(.sync).first!
  state.configDictionary = ["ssids:\(interface.hardMAC.address)":
                              ["Free Wifi": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "dd:dd:dd:dd:dd:dd"]]

  return AccessPointsView().environment(state).environment(interface)
}

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
