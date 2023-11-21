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

extension Configuration {
  struct General {

    // MARK: Initialization

    init(dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Properties

    var dictionary: [String: Any]


    /**
     * Queries whether interfaces set to random may be rerandomized at best-effort.
     * This is yes by default. You can turn it off by adding the key.
     */
    var isForbiddenToRerandomize: Bool {
      guard let restriction = self.dictionary["skip_rerandom"] as? Bool else {
        return false
      }

      return restriction != false
    }

//    /**
//     * Queries whether MAC addresses should be anonymized in GUI and logs.
//     */
    var isAnonymized: Bool {
      return anonymizationSeed.isValid
    }

    /**
     * Queries a seed used for anonymizing MAC addresses shown in GUI and logs.
     */
    var anonymizationSeed: MACAddress {
      guard let seed = self.dictionary["anonymous"] as? String else {
        return MACAddress("")
      }

      return MACAddress(seed)
    }

  }
}
