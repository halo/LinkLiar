/*
 * Copyright (C) halo https://io.github.com/halo/LinkLiar
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files
 * (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify,
 * merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

/**
 * An immutable wrapper for querying the content of the configuration file.
 */
extension Configuration {
  struct Policy {
    
    // MARK: Class Methods
    
    init(_ hardMAC: String, dictionary: [String: Any]) {
      self.dictionary = dictionary
      self.hardMAC = hardMAC
    }
    
    // MARK: Instance Properties
    
    /**
     * Gives access to the underlying dictionary of this configuration.
     */
    var dictionary: [String: Any]
    var hardMAC: String
        
    /**
     * Looks up which action has been defined.
     *
     * Returns `nil` if no (valid) action was defined.
     *
     * - returns: An ``Interface.Action`` or `nil`.
     */
    var action: Interface.Action? {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: String] else { return nil }
      guard let actionName = interfaceDictionary["action"] else { return nil }

      return Interface.Action(rawValue: actionName) ?? nil
    }
    
    /**
     * Looks up which MAC address has been defined.
     * This is useful if the action is "specify".
     *
     * - returns: A valid `MACAddress` or `nil` if no valid address was specified.
     */
    var address: MACAddress? {
      guard let interfaceDictionary = dictionary[hardMAC] as? [String: String] else { return nil }
      guard let rawAddress = interfaceDictionary["address"] else { return nil }

      let address = MACAddress(rawAddress)
      return address.isValid ? address : nil
    }
    
//    {
//      "ssids:00:2a:a5:75:da:32" : {
//        "Some Wifi Name" : "aa:bb:cc:dd:ee:ff",
//        "Another SSID" : "11:22:33:44:55:66"
//      },
//      "ssids:00:2a:a5:11:3f:8b" : {
//        "University SSID" : "55:55:55:55:55:55",
//      },
//    }
    var accessPoints: [AccessPointPolicy] {
      guard let ssidsDictionary = dictionary["ssids:\(hardMAC)"] as? [String: String] else { return [] }
      
      return ssidsDictionary.compactMap({ ssid, rawAddress in
        let address = MACAddress(rawAddress)
        guard !ssid.isEmpty else { return nil }
        guard address.isValid else { return nil }
        guard let validAccessPointPolicy = AccessPointPolicy.initIfValid(ssid: ssid, softMAC: rawAddress) else { return nil }
        return validAccessPointPolicy
      }).sorted()

    }
  }
}
