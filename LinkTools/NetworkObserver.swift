// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Cocoa
import SystemConfiguration

struct  NetworkObserver {
  let callback: () -> Void

  // MARK: Class Methods

  init(callback: @escaping () -> Void) {
    self.callback = callback

    NotificationCenter.default.addObserver(
      forName: .networkConditionsChanged, object: nil, queue: nil, using: notificationCallback
    )

    let store = SCDynamicStoreCreate(nil, "LinkLiar" as CFString, callbackWrapper, nil)!
    let keys = [SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)] as CFArray

    SCDynamicStoreSetNotificationKeys(store, keys, nil)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), SCDynamicStoreCreateRunLoopSource(nil, store, 0), CFRunLoopMode.defaultMode)

    // When the observer starts, we notify immediately.
    // One could say the conditions changed right now "for us".
    callbackWrapper(store, [] as CFArray, nil)
  }

  // MARK: Private Class Methods

  // I wish we could use `NetworkObserver.observe` with a callback closure.
  // But callback types are not compatible with what the SystemConfiguration framework calls.
  // So we resort to sending global notifications that anyone may subscribe to.
  private let callbackWrapper: SCDynamicStoreCallBack = { _, _, _ in
    Log.debug("Network conditions changed")
    NotificationCenter.default.post(name: .networkConditionsChanged, object: nil)
  }

  private func notificationCallback(_ _: Notification) {
    callback()
  }
}
