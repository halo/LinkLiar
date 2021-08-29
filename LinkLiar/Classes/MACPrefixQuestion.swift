/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Cocoa

class MACPrefixQuestion {

  let title: String
  let description: String

  let alert = NSAlert()
  let textField: CopyPastableNSTextField = {
    let field = CopyPastableNSTextField(frame: NSMakeRect(0, 0, 150, 24))
    field.formatter = MACPrefixFormatter()
    field.stringValue = "aa:bb:cc"
    field.placeholderString = "aa:bb:cc"
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

    if (button == NSApplication.ModalResponse.alertFirstButtonReturn) {
      textField.validateEditing()
      return textField.stringValue
    } else {
      return nil
    }
  }

}
