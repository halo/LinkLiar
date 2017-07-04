import Cocoa
import SystemConfiguration

struct  NetworkObserver {

  private static let callback: SCDynamicStoreCallBack = { (store, _, _) in
    Log.debug("Network change detected")
    NetworkObserver.post()
  }

  private static let store = {
    return SCDynamicStoreCreate(nil, "Example" as CFString, NetworkObserver.callback, nil)
  }()

  private static let keys = {
    return [SCDynamicStoreKeyCreateNetworkInterface(nil, kSCDynamicStoreDomainState)]
  }()

  static func observe() {
    SCDynamicStoreSetNotificationKeys(store!, keys as CFArray, nil)
    CFRunLoopAddSource(CFRunLoopGetCurrent(), SCDynamicStoreCreateRunLoopSource(nil, store!, 0), CFRunLoopMode.defaultMode)
    post()
  }

  private static func post() {
    NotificationCenter.default.post(name: .interfacesChanged, object: nil)
  }
}

