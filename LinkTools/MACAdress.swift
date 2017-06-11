import Foundation

class MACAddress: Equatable {

  var humanReadable: String {
    get {
      return isValid ? formatted : "??:??:??:??:??:??"
    }
  }

  var formatted: String {
    get {
      return String(sanitized.characters.enumerated().map() {
        $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
        }.joined().dropFirst())
    }
  }

  var isValid: Bool {
    get {
      return formatted.characters.count == 17
    }
  }

  private var sanitized: String {
    get {
      return raw.lowercased().components(separatedBy: nonHexCharacters).joined()
    }
  }

  private var raw: String
  private lazy var nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

  init(_ raw: String) {
    self.raw = raw
  }

}

func ==(lhs: MACAddress, rhs: MACAddress) -> Bool {
  return lhs.formatted == rhs.formatted
}
