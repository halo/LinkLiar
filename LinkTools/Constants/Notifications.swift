// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension Notification.Name {
  static let menuBarAppeared = Notification.Name("\(Identifiers.gui).notifications.menuBarAppeared")
  static let networkConditionsChanged = Notification.Name("\(Identifiers.gui).notifications.interfacesChanged")
  static let intervalElapsed = Notification.Name("\(Identifiers.gui).notifications.intervalElapsed")
}
