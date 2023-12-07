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
struct Configuration {
  
  // MARK: Class Methods
  
  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
  }
  
  // MARK: Public Instance Properties
  
  ///
  /// Gives (readonly) access to the underlying dictionary of this configuration.
  ///
  var dictionary: [String: Any]

  ///
  /// Queries the version with which the configuration was created.
  ///
  lazy var version: String? = {
    return self.dictionary["version"] as? String
  }()
  
  ///
  /// Queries universal settings.
  ///
  var general: General {
    return General(dictionary: dictionary)
  }
  
  ///
  /// Queries settings of one Interface.
  ///
  func policy(_ hardMAC: MACAddress) -> Policy {
    return Policy(hardMAC.formatted, dictionary: dictionary)
  }
  
  ///
  /// Queries settings of the "default" Interface.
  ///
  var fallbackPolicy: Policy {
    return Policy("default", dictionary: dictionary)
  }
  
}
