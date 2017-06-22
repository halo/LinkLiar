import Foundation

class MACAddressFormatter : Formatter {

  override func string(for obj: Any?) -> String? {
    guard let string = obj as? String else { return nil }
    return string
  }

  override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
    guard obj != nil else { return false }
    obj?.pointee = string as AnyObject
    return true
  }


  override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {


    return true
  }

/*
  func isParasdtialStringValid(_ partialString: String, newEditingString newString: String, errorDescription error: String) -> Bool {
    var foundRange: NSRange
    let disallowedCharacters = CharacterSet(charactersInString: "0123456789:abcdefABCDEF").inverted
    foundRange = (partialString as NSString).rangeOfCharacter(disallowedCharacters)
    if foundRange.location != NSNotFound {
      error = "MAC Adress contains invalid characters"
      NSBeep()
      return false
    }
    if (partialString.characters.count ?? 0) > 17 {
      error = "MAC Adress is too long."
      NSBeep()
      return (false)
    }
    newString = partialString
    return true
  }
 */
}
