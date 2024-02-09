// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import CoreGraphics

extension CGKeyCode {
  static let kVKOption: CGKeyCode = 0x3A
  static let kVKRightOption: CGKeyCode = 0x3D
  static let kVKSpace: CGKeyCode = 0x31

  var isPressed: Bool {
    CGEventSource.keyState(.combinedSessionState, key: self)
  }

  static var optionKeyPressed: Bool {
    Self.kVKOption.isPressed || Self.kVKRightOption.isPressed
  }
}
