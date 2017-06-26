import Cocoa
import SystemConfiguration

class NetworkObserver {
  init() {
    let callback: SCDynamicStoreCallBack = { (store, _, _) in
      Log.debug("Network change detected")
      NotificationCenter.default.post(name: .interfacesChanged, object: nil)
    }

    let store = SCDynamicStoreCreate(nil, "Example" as CFString, callback, nil)
    let keys = [ SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState) ]
    SCDynamicStoreSetNotificationKeys(store!, keys as CFArray, nil)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), SCDynamicStoreCreateRunLoopSource(nil, store!, 0), CFRunLoopMode.defaultMode)

    Log.debug("Loaded")
    NotificationCenter.default.post(name: .interfacesChanged, object: nil)
  }
}

