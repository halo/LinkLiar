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
    
    init(_ hardMAC: MACAddress, dictionary: [String: Any]) {
      self.dictionary = dictionary
      self.hardMAC = hardMAC
    }
    
    // MARK: Instance Properties
    
    /**
     * Gives access to the underlying dictionary of this configuration.
     */
    var dictionary: [String: Any]
    var hardMAC: MACAddress
    
    // MARK: Instance Methods
    
    /**
     * Looks up which action has been defined.
     *
     * Returns `nil` if no valid action was defined.
     *
     * - returns: An ``Interface.Action`` or `nil.
     */
    func action() -> Interface.Action? {
      guard let interfaceDictionary = dictionary[hardMAC.formatted] as? [String: String] else { return nil }
      guard let actionName = interfaceDictionary["action"] else { return nil }

      return Interface.Action(rawValue: actionName) ?? nil
    }
    
  }
}
