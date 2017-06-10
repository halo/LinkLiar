import Cocoa

class Menu {

  lazy var menu = NSMenu()

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

  func refresh() {
    Log.debug("Refreshing...")
    //menu.removeAllItems()
    // menu.update()

    let item4: NSMenuItem = NSMenuItem(title: "One more...", action: #selector(Controller.establishDaemon(_:)), keyEquivalent: "")
    item4.target = Controller.self
    self.menu.addItem(item4)

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
          self.menu.insertItem(item5, at: 0)
       // }


      } else {
        Log.debug("yes helper yes")

      }
      NotificationCenter.default.post(name:.menuChanged, object: nil, userInfo: nil)
    })
  }

  @objc func refreshMenu(_ nsMenu: NSMenu) {
    Log.debug("refreshing menu live--------------------")
    nsMenu.update()


  }

}
