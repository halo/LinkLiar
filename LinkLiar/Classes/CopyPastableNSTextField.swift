/*
 * Copyright (C) 2017 halo https://io.github.com/halo/LinkLiar
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

class CopyPastableNSTextField: NSTextField {

  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    guard event.type == NSEvent.EventType.keyDown else { return false }
    guard event.modifierFlags.contains(NSEvent.ModifierFlags.command) else { return false }
    guard let textView = window?.firstResponder as? NSTextView else { return false }

    let range = textView.selectedRange
    let hasSelectedText = range.length > 0

    switch event.keyCode {

    case 6: // z
      guard let undoManager = textView.undoManager else { return false }
      guard undoManager.canUndo else { return false }
      undoManager.undo()

    case 7: // x
      guard hasSelectedText else { return false }
      textView.cut(self)

    case 8: // c
      guard hasSelectedText else { return false }
      textView.copy(self)

    case 9: // v
      textView.paste(self)

    case 0: // a
      textView.selectAll(self)

    default:
      return false
    }

    return true
  }
}
