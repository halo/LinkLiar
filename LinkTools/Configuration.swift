import Foundation
import os.log

class Configuration: NSObject {
  private typealias `Self` = Configuration

  static var directory = "/Library/Application Support/LinkLiar"
  var path = "\(Self.directory)/config.json"

  func url() -> URL {
    return URL(fileURLWithPath: path)
  }

  func content() -> Data? {
    Log.debug("Config path is \(path)")
    do {
      let data = try Data(contentsOf: url())
      return data
    } catch {
      print(error.localizedDescription)
      return nil
    }
  }

   func read() {

    do {
      let data = content()!
      let json = try JSONSerialization.jsonObject(with: data, options: [])
      if let object = json as? [String: Any] {
        // json is a dictionary
        print(object)
      } else if let object = json as? [Any] {
        // json is an array
        print(object)
      } else {
        print("JSON is invalid")
      }
    } catch {
      print(error.localizedDescription)
    }
  }
}
