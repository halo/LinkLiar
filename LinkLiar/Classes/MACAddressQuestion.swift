import Cocoa

class MACAddressQuestion {

  let title: String
  let description: String

  let alert = NSAlert()
  let textField: CopyPastableNSTextField = {
    let field = CopyPastableNSTextField(frame: NSMakeRect(0, 0, 200, 24))
    field.formatter = MACAddressFormatter()
    field.stringValue = "aa:bb:cc:dd:ee:ff"
    field.placeholderString = "aa:bb:cc:dd:ee:ff"
    return field
  }()

  init(title: String, description: String) {
    self.title = title
    self.description = description

    alert.messageText = title
    alert.informativeText = description

    alert.addButton(withTitle: "OK")
    alert.addButton(withTitle: "Cancel")
    alert.accessoryView = textField
  }

  func ask() -> String? {
    let button = alert.runModal()

    if (button == NSAlertFirstButtonReturn) {
      textField.validateEditing()
      return textField.stringValue
    } else {
      return nil
    }
  }

}
