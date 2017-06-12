import Cocoa

class Menu {

  let menu = NSMenu()

  private var interfaces: [Interface] = []
  private let queue = DispatchQueue(label: "io.github.halo.LinkLiar.menuQueue")

  private func reloadInterfaceItems() {
    queue.sync {
      Log.debug("Reloading Interface menu items")

      // Remove all Interface items
      for item in menu.items {
        if (item.representedObject is Interface) {
          print(item)

          menu.removeItem(item) }
      }

      // Replenish Interfaces and create corresponding items
      interfaces = Interfaces.all()

      for interface in interfaces {
        let titleItem = NSMenuItem(title: interface.title, action: nil, keyEquivalent: "")
        titleItem.representedObject = interface
        menu.addItem(titleItem)

        let macItem = NSMenuItem(title: interface.hardMAC.humanReadable, action: nil, keyEquivalent: "")
        macItem.representedObject = interface
        macItem.target = Controller.self
        menu.addItem(macItem)
      }
    }
  }

  func update() {
    Log.debug("Updating menu...")
    reloadInterfaceItems()
  }
  



  func load() {

    let item: NSMenuItem = NSMenuItem(title: "Install Helper", action: #selector(Controller.authorize(_:)), keyEquivalent: "")
    item.target = Controller.self
    menu.addItem(item)

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
