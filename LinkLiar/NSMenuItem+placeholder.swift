/*
 * MIT License - Copyright 2017 halo - https://github.com/halo/LinkLiar
 */

import Cocoa

extension NSMenuItem {

  // MARK: Getting a Placeholder Item

  /**
   * Returns an invisible menu item so that its successor may
   * be revealed via modifier keys using `keyEquivalentModifierMask`.
   *
   * - seealso: Analogous to `separator()`.
   */
  class func placeholder() -> NSMenuItem {
    let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    item.view = NSView(frame: NSMakeRect(0, 0, 0, 0))
    item.isEnabled = false
    return item
  }

}
