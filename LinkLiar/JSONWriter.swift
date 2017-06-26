import Foundation
import os.log

class JSONWriter {

  private var path: String

  private var url: URL {
    return URL(fileURLWithPath: path)
  }

  init(filePath: String) {
    self.path = filePath
  }

  func write(_ dictionary: [String: Any]) {

    do {
      let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) as NSData
      let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
      Log.error("json string = \(jsonString)")

      do {
        try jsonString.write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
      } catch let error as NSError {
        Log.error("Could not write: \(error)")
      }

    } catch let error as NSError {
      Log.error("Could not serialize: \(error)")
    }

  }
  
}
