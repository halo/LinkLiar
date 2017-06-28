import Cocoa

class Menu {

  let menu = NSMenu()

  private var interfaces: [Interface] = []
  private let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.menuQueue")

  private lazy var advancedMenuPlaceholderItem: NSMenuItem = {
    let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    item.view = NSView(frame: NSMakeRect(0, 0, 0, 0))
    return item
  }()

  private lazy var advancedMenuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Advanced", action: nil, keyEquivalent: "")
    item.submenu = self.advancedSubmenu
    item.keyEquivalentModifierMask = .option
    item.isAlternate = true
    return item
  }()

  /// The Developer Menu is revealed as alternative to this invisible dummy while holding the option key.
  private lazy var developerMenuPlaceholderItem: NSMenuItem = {
    let item = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    item.view = NSView(frame: NSMakeRect(0, 0, 0, 0))
    return item
  }()

  private lazy var developerMenuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Developer", action: nil, keyEquivalent: "")
    item.submenu = self.developerSubmenu
    item.keyEquivalentModifierMask = [.control, .option]
    item.isAlternate = true
    return item
  }()

  private lazy var advancedSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.toggleDaemonItem)
    item.addItem(self.launchAtLoginItem)
    item.addItem(self.showLogsItem)
    return item
  }()

  private lazy var toggleDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Toggle Daemon", action: #selector(Controller.helperVersion(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var launchAtLoginItem: NSMenuItem = {
    let item = NSMenuItem(title: "Launch on Login", action: #selector(Controller.helperVersion(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var showLogsItem: NSMenuItem = {
    let item = NSMenuItem(title: "Show Logs", action: #selector(Controller.showLogs(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var developerSubmenu: NSMenu = {
    let item: NSMenu = NSMenu()
    item.addItem(self.installHelperItem)
    item.addItem(self.implodeHelperItem)
    item.addItem(self.helperVersionItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.createConfigDirectoryItem)
    item.addItem(self.resetConfigItem)
    item.addItem(NSMenuItem.separator())
    item.addItem(self.configureDaemonItem)
    item.addItem(self.activateDaemonItem)
    item.addItem(self.deactivateDaemonItem)
    return item
  }()

  private lazy var authorizeHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var installHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Install Helper", action: #selector(Controller.installHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var implodeHelperItem: NSMenuItem = {
    let item = NSMenuItem(title: "Remove Helper", action: #selector(Controller.implodeHelper(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var helperVersionItem: NSMenuItem = {
    let item = NSMenuItem(title: "Helper Version", action: #selector(Controller.helperVersion(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var createConfigDirectoryItem: NSMenuItem = {
    let item = NSMenuItem(title: "Create Config Dir", action: #selector(Controller.createConfigDir(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var resetConfigItem: NSMenuItem = {
    let item = NSMenuItem(title: "Reset Config File", action: #selector(Controller.resetConfig(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var configureDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Configure Daemon", action: #selector(Controller.configureDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var activateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Activate Daemon", action: #selector(Controller.activateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var deactivateDaemonItem: NSMenuItem = {
    let item = NSMenuItem(title: "Deactivate Daemon", action: #selector(Controller.deactivateDaemon(_:)), keyEquivalent: "")
    item.target = Controller.self
    return item
  }()

  private lazy var helpItem: NSMenuItem = {
    return NSMenuItem(title: "Help...", action: #selector(NSApplication.showHelp(_:)), keyEquivalent: "")
  }()

  private lazy var quitItem: NSMenuItem = {
    return NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "")
  }()

  // MARK: Initialization

  init() {
    NotificationCenter.default.addObserver(forName: .softMacIdentified, object:nil, queue:nil, using:softMacIdentified)
    NotificationCenter.default.addObserver(forName: .configChanged, object:nil, queue:nil, using:configChanged)

    menu.addItem(authorizeHelperItem)
    menu.addItem(NSMenuItem.separator())
    // -- Here be Interfaces --
    menu.addItem(NSMenuItem.separator())
    menu.addItem(defaultMenuItem)
    menu.addItem(NSMenuItem.separator())
    menu.addItem(advancedMenuPlaceholderItem)
    menu.addItem(advancedMenuItem)
    menu.addItem(developerMenuPlaceholderItem)
    menu.addItem(developerMenuItem)
    menu.addItem(helpItem)
    menu.addItem(quitItem)
  }

  func update() {
    Log.debug("Updating menu...")
    reloadInterfaceItems()
  }

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
        let titleItem = NSMenuItem(title: interface.title, action: nil, keyEquivalent: "")
        titleItem.representedObject = interface
        menu.insertItem(interfaceMenuItem(interface: interface), at: 2)
        menu.insertItem(titleItem, at: 2)
        menu.addItem(NSMenuItem.separator())
      }
    }
  }

  func interfaceMenuItem(interface: Interface) -> NSMenuItem {
    let item = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
    item.representedObject = interface
    item.target = Controller.self
    item.tag = 42

    item.title = interface.softMAC.isValid ? interface.softMAC.humanReadable : "";
    item.state = interface.hasOriginalMAC ? 1 : 0
    item.onStateImage = #imageLiteral(resourceName: "InterfaceLeaking")
    item.submenu = interfaceSubMenuItem(interface: interface)
    return item
  }

  func interfaceSubMenuItem(interface: Interface) -> NSMenu {
    let submenu: NSMenu = NSMenu()

    let vendorNameItem = NSMenuItem(title: "Vendor here", action: nil, keyEquivalent: "")
    submenu.addItem(vendorNameItem)
    submenu.addItem(NSMenuItem.separator())

    if (interface.isPoweredOffWifi) {
      let poweredOffItem = NSMenuItem(title: "Powered off", action: nil, keyEquivalent: "")
      submenu.addItem(poweredOffItem)
    } else {

      let action = Config.instance.actionForInterface(interface.hardMAC)

      let ignoreItem: NSMenuItem = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreInterface(_:)), keyEquivalent: "")
      ignoreItem.representedObject = interface
      ignoreItem.target = Controller.self
      ignoreItem.state = action == Interface.Action.ignore ? 1 : 0
      submenu.addItem(ignoreItem)

      let randomizeItem: NSMenuItem = NSMenuItem(title: "Random", action: #selector(Controller.randomizeInterface(_:)), keyEquivalent: "")
      randomizeItem.representedObject = interface
      randomizeItem.target = Controller.self
      randomizeItem.state = action == Interface.Action.random ? 1 : 0
      submenu.addItem(randomizeItem)

      let specifyItem: NSMenuItem = NSMenuItem(title: "Define manually", action: #selector(Controller.specifyInterface(_:)), keyEquivalent: "")
      specifyItem.representedObject = interface
      specifyItem.target = Controller.self
      specifyItem.state = action == Interface.Action.specify ? 1 : 0
      submenu.addItem(specifyItem)

      let originalizeItem: NSMenuItem = NSMenuItem(title: "Keep original", action: #selector(Controller.originalizeInterface(_:)), keyEquivalent: "")
      originalizeItem.representedObject = interface
      originalizeItem.target = Controller.self
      originalizeItem.state = action == Interface.Action.original ? 1 : 0
      submenu.addItem(originalizeItem)
    }
    return submenu
  }

  private lazy var defaultMenuItem: NSMenuItem = {
    let item = NSMenuItem(title: "Default", action: nil, keyEquivalent: "")
    item.target = Controller.self
    item.submenu = self.defaultSubMenuItem
    return item
  }()

  private lazy var defaultSubMenuItem: NSMenu = {
    let submenu: NSMenu = NSMenu()
    submenu.addItem(self.ignoreDefaultItem)
    submenu.addItem(self.randomizeDefaultItem)
    return submenu
  }()

  private lazy var ignoreDefaultItem: NSMenuItem = {
    let item = NSMenuItem(title: "Do nothing", action: #selector(Controller.ignoreDefaultInterface(_:)), keyEquivalent: "")
    item.target = Controller.self
    //item.state = Config.instance.actionForDefaultInterface() == Interface.Action.ignore ? 1 : 0
    return item
  }()

  private lazy var randomizeDefaultItem: NSMenuItem = {
    let item = NSMenuItem(title: "Random", action: #selector(Controller.randomizeDefaultInterface(_:)), keyEquivalent: "")
    item.target = Controller.self
    //item.state = Config.instance.actionForDefaultInterface() == Interface.Action.random ? 1 : 0
    return item
  }()

  func softMacIdentified(_ notification: Notification) {
    let interface: Interface = notification.object as! Interface

    queue.sync {
      for item in menu.items {
        guard (item.tag == 42) else { continue }
        guard (item.representedObject is Interface) else { continue }
        guard ((item.representedObject as! Interface).hardMAC == interface.hardMAC) else { continue }
        let index = menu.index(of: item)
        menu.insertItem(interfaceMenuItem(interface: interface), at: index)
        menu.removeItem(item)
      }
    }
    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }
  
  func configChanged(_ notification: Notification) {
    ignoreDefaultItem.state = Config.instance.actionForDefaultInterface() == Interface.Action.ignore ? 1 : 0
    randomizeDefaultItem.state = Config.instance.actionForDefaultInterface() == Interface.Action.random ? 1 : 0

    NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
  }

  func test() {
    Intercom.helperVersion(reply: { rawVersion in

      if (rawVersion == nil) {
        Log.debug("I miss versino or helper or what!")

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
