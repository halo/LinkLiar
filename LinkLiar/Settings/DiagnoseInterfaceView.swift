/*
 * Copyright (C)  halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
 * persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

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
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = ["ssids:\(interface.hardMAC.formatted)": 
//                              ["Free Wifi": "aa:aa:aa:aa:aa:aa", "Coffeeshop": "dd:dd:dd:dd:dd:dd"]]
//  
//  return AccessPointsView().environment(state).environment(interface)
// }

// #Preview("Specified MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "specify", "address": "aa:bb:cc:dd:ee:ff"]]
//
//  return AccessPointView().environment(state).environment(interface)
// }
//
//
// #Preview("Original MAC") {
//  let state = LinkState()
//  let interface = Interfaces.all(asyncSoftMac: false).first!
//  state.configDictionary = [interface.hardMAC.formatted: ["action": "original"]]
//
//  return AccessPointView().environment(state).environment(interface)
// }
//
