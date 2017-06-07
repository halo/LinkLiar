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

  //private func data() -> Data? {
  //  let data = try? Data(contentsOf: path())
    //print(String.init(data: data, encoding: String.Encoding.utf8))
  //  return data
  //}
/*
  func reads() -> [String: Any]? {
    guard let json = data() else {
      os_log("could not load json data again")
      return nil
    }
    
    if let dictionary = try? JSONSerialization.jsonObject(with: json) as! [String: Any] { return dictionary }
    os_log("could not parse")
    return nil
  }
*/
   func read() {

    //_ = URLet url(fileURLWithPath: "/Users/orange/Code/LinkLiar")


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
