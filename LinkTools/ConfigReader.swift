import Foundation
import os.log

class ConfigReader {

  var path: String
  var url: URL {
    get {
      return URL(fileURLWithPath: path)
    }
  }

  init(filePath: String) {
    self.path = filePath
  }

  func data() -> Data? {
    do {
      let data = try Data(contentsOf: url)
      return data
    } catch {
      Log.debug(error.localizedDescription)
      return nil
    }
  }

   func read() {
    do {
      let data = self.data()!
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
