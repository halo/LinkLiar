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
    menu.addItem(authorizeSeparatorItem)
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
    queryHelperAlive()
    queryHelperVersion()
  }

  private lazy var authorizeItem: NSMenuItem = {
    let item = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var authorizeSeparatorItem: NSMenuItem = {
    return NSMenuItem.separator()
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
        menu.insertItem(NSMenuItem.separator(), at: 2)
        menu.insertItem(interfaceSubmenu.menuItem, at: 2)
        menu.insertItem(interfaceSubmenu.titleMenuItem, at: 2)
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

  func queryHelperAlive() {
    Intercom.helperAlive(reply: { alive in
      if alive {
        Log.debug("Helper is alive")

      } else {
        Log.debug("Helper is dead")
        self.authorizeItem.isHidden = false
        self.authorizeSeparatorItem.isHidden = false
      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

  func queryHelperVersion() {
    Intercom.helperVersion(reply: { version in
      if (version.isCompatible(other: AppDelegate.version)) {
        Log.debug("Helper is compatible")
        self.authorizeItem.isHidden = true
        self.authorizeSeparatorItem.isHidden = true

      } else {
        Log.debug("Helper is not compatible")
        self.authorizeItem.isHidden = false
        self.authorizeSeparatorItem.isHidden = false
      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

}
