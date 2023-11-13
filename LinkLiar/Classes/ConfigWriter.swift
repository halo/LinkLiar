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

import Foundation
import os.log

class ConfigWriter {

  // MARK: Class Methods

  static func setInterfaceActionToHidden(interface: Interface, isOn: Bool, state: LinkState) {
    var dictionary = state.configDictionary
    dictionary["version"] = state.version.formatted
    let newAction = isOn ? "hide" : "ignore"
    
    var interfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? ["action": newAction]
    interfaceDictionary.updateValue(newAction, forKey: "action")
    
    dictionary[interface.hardMAC.formatted] = interfaceDictionary
    
//    let newInterfaceDictionary = dictionary[interface.hardMAC.formatted] as? [String: String] ?? ["action": "hide"]
    
//    if interfaceDictionary
    Log.debug("Changing config to ignore Interface \(interface.hardMAC.formatted)")
    JSONWriter(filePath: Paths.configFile).write(dictionary)
  }

}
