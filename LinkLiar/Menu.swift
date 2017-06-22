import Cocoa

class Menu {

  let menu = NSMenu()

  private var interfaces: [Interface] = []
  private let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.menuQueue")

  private let developerMenu: NSMenuItem = {
    let submenu: NSMenu = NSMenu()

    let installHelperItem: NSMenuItem = NSMenuItem(title: "Install Helper", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    installHelperItem.target = Controller.self
    submenu.addItem(installHelperItem)

    let resetConfigItem: NSMenuItem = NSMenuItem(title: "Reset Config", action: #selector(Controller.resetConfig(_:)), keyEquivalent: "")
    resetConfigItem.target = Controller.self
    submenu.addItem(resetConfigItem)

    let root: NSMenuItem = NSMenuItem(title: "Advanced", action: nil, keyEquivalent: "")
    root.submenu = submenu
    return root
  }()

  init() {
    NotificationCenter.default.addObserver(forName: .softMacIdentified, object:nil, queue:nil, using:softMacIdentified)
    menu.addItem(developerMenu)
  }

  func update() {
    Log.debug("Updating menu...")
    print(Config.instance)
    print(Config.observer)
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
      interfaces = Interfaces.all(async: true)

      // Replenish corresponding items
      for interface in interfaces {
        let titleItem = NSMenuItem(title: interface.title, action: nil, keyEquivalent: "")
        titleItem.representedObject = interface
        menu.addItem(titleItem)
        menu.addItem(interfaceMenuItem(interface: interface))
      }
      menu.addItem(NSMenuItem.separator())
    }
  }

  func interfaceMenuItem(interface: Interface) -> NSMenuItem {
    let item = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
    item.representedObject = interface
    item.target = Controller.self
    item.tag = 42

    item.title = interface.softMAC.humanReadable;
    item.state = interface.hasOriginalMAC ? 1 : 0
    item.onStateImage = #imageLiteral(resourceName: "InterfaceLeaking")
    //item.onStateImage = #imageLiteral(resourceName: "MenuIconLeaking")
    //item.onStateImage.isTemplate = true
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

      let action = Config.instance.actionForInterface(interface.hardMAC.formatted)

      let ignoreItem: NSMenuItem = NSMenuItem(title: "Do nothing", action: #selector(Controller.forgetInterface(_:)), keyEquivalent: "")
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


    }
    return submenu
  }

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
  





  func load() {


    menu.addItem(NSMenuItem.separator())

    let item2: NSMenuItem = NSMenuItem(title: "Helper Version", action: #selector(Controller.helperVersion(_:)), keyEquivalent: "")
    item2.target = Controller.self
    menu.addItem(item2)

    let item3: NSMenuItem = NSMenuItem(title: "Create Config dir", action: #selector(Controller.createConfigDir(_:)), keyEquivalent: "")
    item3.target = Controller.self
    menu.addItem(item3)

    let item4: NSMenuItem = NSMenuItem(title: "Establish daemon", action: #selector(Controller.establishDaemon(_:)), keyEquivalent: "")
    item4.target = Controller.self
    menu.addItem(item4)

    let item5: NSMenuItem = NSMenuItem(title: "Activate daemon", action: #selector(Controller.activateDaemon(_:)), keyEquivalent: "")
    item5.target = Controller.self
    menu.addItem(item5)

    let item6: NSMenuItem = NSMenuItem(title: "Deativate daemon", action: #selector(Controller.deactivateDaemon(_:)), keyEquivalent: "")
    item6.target = Controller.self
    menu.addItem(item6)

    menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    // menu.delegate = self

  }



  func test() {
    Log.debug("Refreshing...")


    //menu.removeAllItems()
    // menu.update()

    let item4: NSMenuItem = NSMenuItem(title: "One more...", action: #selector(Controller.establishDaemon(_:)), keyEquivalent: "")
    item4.target = Controller.self
    //self.menu.addItem(item4)

    Intercom.helperVersion(reply: { rawVersion in

      //menu.removeAllItems()
      //self.load()

      if (rawVersion == nil) {
        Log.debug("I miss versino or helper or what!")

        let item5: NSMenuItem = NSMenuItem(title: "Authorize...", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
        item5.tag = 42
        item5.target = Controller.self
        //if (menu.item(withTag: 42) == nil) {
          Log.debug("ADDING")
          //self.menu.insertItem(item5, at: 0)
       // }


      } else {
        Log.debug("yes helper yes")

      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

}
