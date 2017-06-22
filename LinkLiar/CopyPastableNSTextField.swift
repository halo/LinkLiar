import Cocoa

class CopyPastableNSTextField: NSTextField {

  override func performKeyEquivalent(with event: NSEvent) -> Bool {
    guard event.type == NSEventType.keyDown else { return false }
    guard event.modifierFlags.contains(.command) else { return false }
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
