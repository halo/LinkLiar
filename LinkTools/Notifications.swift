import Foundation

extension Notification.Name {
  static let menuChanged = Notification.Name("\(Identifiers.gui).notifications.menuChanged")
  static let configChanged = Notification.Name("\(Identifiers.gui).notifications.configChanged")
  static let softMacIdentified = Notification.Name("\(Identifiers.gui).notifications.softMacIdentified")
  static let interfacesChanged = Notification.Name("\(Identifiers.gui).notifications.interfacesChanged")
  static let intervalElapsed = Notification.Name("\(Identifiers.gui).notifications.intervalElapsed")
}
