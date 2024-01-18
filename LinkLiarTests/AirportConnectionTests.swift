// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class AirportConnectionTests: XCTestCase {
  func testSsid() {
    var connection = Airport.Connection(stubOutput:"""
            agrCtlRSSI: -62
            agrExtRSSI: 0
           agrCtlNoise: -89
           agrExtNoise: 0
                 state: running
               op mode: station
            lastTxRate: 650
               maxRate: 867
       lastAssocStatus: 0
           802.11 auth: open
             link auth: wpa2-psk
                 BSSID: aa:bb:cc:dd:ee:ff
                  SSID: Thé Coffeeshop
                   MCS: 7
         guardInterval: 400
                   NSS: 2
               channel: 52,80
       """)

    XCTAssertEqual("Thé Coffeeshop", connection.ssid)
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", connection.bssid)
  }

  func testSsidPreventsInjection() {
    var connection = Airport.Connection(stubOutput:"""
           agrCtlRSSI: -60
           agrExtRSSI: 0
          agrCtlNoise: -89
          agrExtNoise: 0
                state: running
              op mode: station
           lastTxRate: 702
              maxRate: 867
      lastAssocStatus: 0
          802.11 auth: open
            link auth: wpa2-psk
                BSSID: aa:bb:cc:dd:ee:ff
                 SSID: My perfect SSID: SSID: injection
                  MCS: 7
        guardInterval: 400
                  NSS: 2
              channel: 52,80
      """)

    XCTAssertEqual("My perfect SSID: SSID: injection", connection.ssid)
    XCTAssertEqual("aa:bb:cc:dd:ee:ff", connection.bssid)
  }

  func testSsidEmpty() {
    var connection = Airport.Connection(stubOutput:"""
           agrCtlRSSI: -60
           agrExtRSSI: 0
          agrCtlNoise: -89
          agrExtNoise: 0
                state: running
              op mode: station
           lastTxRate: 702
              maxRate: 867
      lastAssocStatus: 0
          802.11 auth: open
            link auth: wpa2-psk
                BSSID:
                 SSID:
                  MCS: 7
        guardInterval: 400
                  NSS: 2
              channel: 52,80
      """)

    XCTAssertNil(connection.ssid)
    XCTAssertNil(connection.bssid)
  }

  func testSsidDeactivated() {
    var connection = Airport.Connection(stubOutput:"""
      AirPort: Off
      """)

    XCTAssertNil(connection.ssid)
    XCTAssertNil(connection.bssid)
  }

  func testSsidDisassociated() {
    var connection = Airport.Connection(stubOutput:"""
          agrCtlRSSI: 0
          agrExtRSSI: 0
         agrCtlNoise: 0
         agrExtNoise: 0
               state: init
             op mode:
          lastTxRate: 0
             maxRate: 0
     lastAssocStatus: 0
         802.11 auth: open
           link auth: wpa2-psk
               BSSID: 0:0:0:0:0:0
                SSID:
                 MCS: -1
       guardInterval: -1
                 NSS: -1
             channel: 1
     """)

    XCTAssertNil(connection.ssid)
    XCTAssertNil(connection.bssid)
  }
}
