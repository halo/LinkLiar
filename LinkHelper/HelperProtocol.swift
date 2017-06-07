import Foundation

struct HelperConstants {
  static let machServiceName = "io.github.halo.linkhelper"
}

@objc(HelperProtocol)
protocol HelperProtocol {
  func version(reply: (String) -> Void)
  func createConfigDirectory(reply: (Bool) -> Void)

}
