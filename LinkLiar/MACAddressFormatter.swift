import Foundation

class MACAddressFormatter : Formatter {

  let disallowedCharacters = CharacterSet(charactersIn: "0123456789:abcdefABCDEF").inverted

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
    if partialString.characters.count > 17 {
      return false
    }

    if partialString.rangeOfCharacter(from: disallowedCharacters) != nil {
      return false
    }

    return true
  }
  
}
