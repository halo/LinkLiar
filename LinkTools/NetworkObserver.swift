/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Cocoa
import SystemConfiguration

struct  NetworkObserver {
  
  static func observe() {
    let store = SCDynamicStoreCreate(nil, "LinkLiar" as CFString, NetworkObserver.callback, nil)!
    let keys = [SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)] as CFArray
    
    SCDynamicStoreSetNotificationKeys(store, keys , nil)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), SCDynamicStoreCreateRunLoopSource(nil, store, 0), CFRunLoopMode.defaultMode)
    
    // When the observer starts, we notify immediately.
    // One could say the conditions changed right now "for us".
    callback(store, [] as CFArray, nil)
  }
  
  // I wish we could use `NetworkObserver.observe` with a callback closure.
  // But callback types are not compatible with what the SystemConfiguration framework calls.
  // So we resort to sending global notifications that anyone may subscribe to.
  private static let callback: SCDynamicStoreCallBack = { (_, _, _) in
    Log.debug("Network conditions changed")
    NotificationCenter.default.post(name: .networkConditionsChanged, object: nil)
  }
  
}
