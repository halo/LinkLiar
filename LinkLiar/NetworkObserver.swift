import Cocoa
import SystemConfiguration
import os.log

extension Notification.Name {
  static let interfacesChangedNotification = Notification.Name("interfacesChangedNotification")
}

class NetworkObserver: NSObject {
  override init() {
    super.init()

    let callback: SCDynamicStoreCallBack = { (store, _, _) in
      os_log("Network change detected")
      NotificationCenter.default.post(name: .interfacesChangedNotification, object: nil)
    }

    let store = SCDynamicStoreCreate(nil, "Example" as CFString, callback, nil)
    let keys = [ SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState) ]
    SCDynamicStoreSetNotificationKeys(store!, keys as CFArray, nil)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), SCDynamicStoreCreateRunLoopSource(nil, store!, 0), CFRunLoopMode.defaultMode)

    os_log("Loaded")
    NotificationCenter.default.post(name: .interfacesChangedNotification, object: nil)
  }
}

