// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import XCTest
@testable import LinkLiar

class AirportScannerTests: XCTestCase {
  func testScan() {
    let scanner = Airport.Scanner()
    scanner.stubOutput = """
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <array>
        <dict>
          <key>NOISE</key>
          <integer>-95</integer>
          <key>PHY_MODE</key>
          <integer>400</integer>
          <key>RATES</key>
          <array>
            <integer>6</integer>
            <integer>9</integer>
            <integer>12</integer>
            <integer>18</integer>
            <integer>24</integer>
            <integer>36</integer>
            <integer>48</integer>
            <integer>54</integer>
          </array>
          <key>RSSI</key>
          <integer>-92</integer>
          <key>SCAN_RESULT_FROM_PROBE_RSP</key>
          <false/>
          <key>SCAN_RESULT_NET_FLAGS</key>
          <array/>
          <key>SCAN_RESULT_OWE_MULTI_SSID</key>
          <false/>
          <key>BSSID</key>
          <string>6:aa:bb:cc:2:dd</string>
          <key>SNR</key>
          <integer>3</integer>
          <key>SSID_STR</key>
          <string>Thé Coffeeshop</string>
          <key>VHT_CAPS</key>
          <dict>
            <key>VHT_CAPS</key>
            <integer>864055730</integer>
          </dict>
          <key>WPS_BEACON_IE</key>
          <dict>
            <key>IE_KEY_WPS_SC_STATE</key>
            <integer>2</integer>
          </dict>
        </dict>
        <dict>
          <key>RSN_IE</key>
          <dict>
            <key>IE_KEY_RSN_AUTHSELS</key>
            <array>
              <integer>2</integer>
            </array>
            <key>IE_KEY_RSN_CAPS</key>
            <dict>
              <key>GTKSA_REPLAY_COUNTERS</key>
              <integer>1</integer>
              <key>MFP_CAPABLE</key>
              <false/>
              <key>MFP_REQUIRED</key>
              <false/>
              <key>NO_PAIRWISE</key>
              <false/>
              <key>OCV</key>
              <false/>
              <key>PRE_AUTH</key>
              <false/>
              <key>PTKSA_REPLAY_COUNTERS</key>
              <integer>16</integer>
              <key>RSN_CAPABILITIES</key>
              <integer>12</integer>
            </dict>
            <key>IE_KEY_RSN_MCIPHER</key>
            <integer>4</integer>
            <key>IE_KEY_RSN_UCIPHERS</key>
            <array>
              <integer>4</integer>
            </array>
            <key>IE_KEY_RSN_VERSION</key>
            <integer>1</integer>
          </dict>
          <key>BSSID</key>
          <string>aa:c:bb:cc:dd:ee</string>
          <key>RSSI</key>
          <integer>-87</integer>
          <key>SCAN_RESULT_FROM_PROBE_RSP</key>
          <false/>
          <key>SCAN_RESULT_NET_FLAGS</key>
          <array/>
          <key>SCAN_RESULT_OWE_MULTI_SSID</key>
          <false/>
          <key>SNR</key>
          <integer>8</integer>
          <key>SSID_STR</key>
          <string>The Starship</string>
          <key>VHT_CAPS</key>
          <dict>
            <key>VHT_CAPS</key>
            <integer>864055698</integer>
          </dict>
          <key>VHT_IE</key>
          <dict>
            <key>VHT_BASIC_MCS_SET</key>
            <integer>-6</integer>
            <key>VHT_CENTER_CHAN_SEGMENT0</key>
            <integer>0</integer>
            <key>VHT_CENTER_CHAN_SEGMENT1</key>
            <integer>0</integer>
            <key>VHT_CHAN_WIDTH</key>
            <integer>0</integer>
          </dict>
          <key>WPS_BEACON_IE</key>
          <dict>
            <key>IE_KEY_WPS_SC_STATE</key>
            <integer>2</integer>
          </dict>
        </dict>
      </array>
      </plist>
    """

    let accessPoints = scanner.accessPoints()
    XCTAssertNotNil(accessPoints)
    XCTAssertEqual(2, accessPoints.count)

    let firstPoint = accessPoints.first!
    XCTAssertEqual(SSID("Thé Coffeeshop"), firstPoint.ssid)
    XCTAssertEqual(MAC("06:aa:bb:cc:02:dd"), firstPoint.bssid)

    let secondPoint = accessPoints.last!
    XCTAssertEqual(SSID("The Starship"), secondPoint.ssid)
    XCTAssertEqual(MAC("aa:c:bb:cc:dd:ee"), secondPoint.bssid)
  }
}
