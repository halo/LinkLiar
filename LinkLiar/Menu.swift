import Foundation
import Cocoa

class Menu: NSObject {
  let menu = NSMenu()

  override init() {
    super.init()

    let item: NSMenuItem = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self

    menu.addItem(NSMenuItem.separator())
    menu.addItem(item)
    //menu.addItem(NSMenuItem(title: "Helper Version", action: #selector(helperVersion(_:)), keyEquivalent: "h"))
    //menu.addItem(NSMenuItem(title: "Create Config dir", action: #selector(createConfigDir(_:)), keyEquivalent: "h"))
    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

  }

}
