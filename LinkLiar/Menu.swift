import Cocoa

class Menu {

  let menu = NSMenu()

  private var interfaces: [Interface] = []
  private let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.menuQueue")

  private lazy var advancedSubmenu = AdvancedSubmenu()
  private lazy var developerSubmenu = DeveloperSubmenu()
  private lazy var defaultSubmenu = DefaultSubmenu()

  private lazy var helpItem: NSMenuItem = {
    return NSMenuItem(title: "Help...", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
  }()

  private lazy var quitItem: NSMenuItem = {
    return NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
  }()

  // MARK: Initialization

  init() {
    NotificationCenter.default.addObserver(forName: .softMacIdentified, object: nil, queue: nil, using: softMacIdentified)
    NotificationCenter.default.addObserver(forName: .configChanged, object: nil, queue: nil, using: configChanged)

    menu.addItem(authorizeItem)
    menu.addItem(NSMenuItem.separator())
    // <-- Here be Interfaces -->
    menu.addItem(NSMenuItem.separator())
    menu.addItem(defaultSubmenu.menuItem)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(advancedSubmenu.placeholderItem)
    menu.addItem(advancedSubmenu.menuItem)
    menu.addItem(developerSubmenu.placeholderItem)
    menu.addItem(developerSubmenu.menuItem)
    menu.addItem(helpItem)
    menu.addItem(quitItem)
  }

  func update() {
    Log.debug("Updating menu...")
    reloadInterfaceItems()
  }

  private lazy var authorizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private func reloadInterfaceItems() {
    queue.sync {
      Log.debug("Reloading Interface menu items")

      // Remove all Interface items
      for item in menu.items {
        if (item.representedObject is Interface) {
         // print(item)

          menu.removeItem(item) }
      }

      // Replenish Interfaces
      // In reverse order because we insert one by one at the top of the menu
      interfaces = Interfaces.all(async: true).reversed()

      // Replenish corresponding items
      for interface in interfaces {
        let interfaceSubmenu = InterfaceSubmenu(interface)
        menu.insertItem(interfaceSubmenu.menuItem, at: 2)
        menu.insertItem(interfaceSubmenu.titleMenuItem, at: 2)
        menu.addItem(NSMenuItem.separator())
      }
    }
  }


  func softMacIdentified(_ notification: Notification) {
    let interface: Interface = notification.object as! Interface

    queue.sync {
      for item in menu.items {
        guard (item.tag == 42) else { continue }
        guard (item.representedObject is Interface) else { continue }
        guard ((item.representedObject as! Interface).hardMAC == interface.hardMAC) else { continue }
        let index = menu.index(of: item)
        let interfaceSubmenu = InterfaceSubmenu(interface)
        menu.insertItem(interfaceSubmenu.menuItem, at: index)
        menu.removeItem(item)
      }
    }
    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }
  
  func configChanged(_ notification: Notification) {
    defaultSubmenu.update()
    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }

  func test() {
    Intercom.helperVersion(reply: { rawVersion in

      if (rawVersion == nil) {
        Log.debug("I miss version or helper or what!")

        let item5: NSMenuItem = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
        item5.tag = 42
        item5.target = Controller.self


      } else {
        Log.debug("yes helper yes")

      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

}
