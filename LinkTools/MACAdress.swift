import Foundation

class MACAddress {

  private var raw: String
  private lazy var nonHexCharacters = CharacterSet(charactersIn: "0123456789abcdef").inverted

  init(_ raw: String) {
    self.raw = raw
  }

  func formatted() -> String {
    return String(sanitized().characters.enumerated().map() {
      $0.offset % 2 == 1 ? [$0.element] : [":", $0.element]
    }.joined().dropFirst())
  }

  private func sanitized() -> String {
    return raw.lowercased().components(separatedBy: nonHexCharacters).joined()
  }

}
