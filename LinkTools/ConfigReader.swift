import Foundation
import os.log

class ConfigReader {

  private var path: String

  private var url: URL {
    get {
      return URL(fileURLWithPath: path)
    }
  }

  init(filePath: String) {
    self.path = filePath
  }

  lazy var data: Data? = {
    do {
      let result = try Data(contentsOf: self.url)
      return result
    } catch {
      Log.debug(error.localizedDescription)
      return nil
    }
  }()

  lazy var object: [String: Any] = {
    guard let jsonData = self.data else {
      Log.error("Missing JSON data to parse.")
      return [String: Any]()
    }

    do {
      let json = try JSONSerialization.jsonObject(with: jsonData, options: [])
      if let object = json as? [String: Any] {
        return object
      } else {
        Log.debug("JSON is not a Key-Value object")
      }
    } catch {
      print(error.localizedDescription)
    }
    return [String: Any]()
  }()
}
