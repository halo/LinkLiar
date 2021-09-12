/*
 * Copyright (C) 2012-2021 halo https://io.github.com/halo/LinkLiar
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
  struct Prefixes {

    // MARK: Public Instance Properties

    var dictionary: [String: Any]

    // MARK: Initialization

    init(dictionary: [String: Any]) {
      self.dictionary = dictionary
    }

    // MARK: Public Instance Methods

    /**
     * Looks up which vendors are specified.
     * If there are absolutely no prefixes defined (neither vendors nor custom)
     * then the fallback Vendor (Apple) is returned.
     *
     * Because we need always some prefix to use for randomization.
     * Also, this makes upgrading LinkLiar simpler (i.e. no vendors and no prefixes
     * defined in settings file means use some default and persist that as new setting)
     *
     * - returns: An Array of valid `Vendor`s or an empty Array if there are none.
     */
    var vendors: [Vendor] {
      guard let vendorIDs = dictionary["vendors"] as? [String] else { return defaultVendors }

      let vendors = Set(vendorIDs).compactMap { string -> Vendor? in
        return Vendors.find(string)
      }

      // If there are vendors defined directly, return them.
      guard vendors.isEmpty else { return Array(vendors).sorted() }
      Log.debug("Currently no vendors active")

      // We always need *some* prefix. If there are custom prefixes,
      // we can rely on them and don't need to fall back here to anything.
      guard prefixes.isEmpty else { return [] }

      return defaultVendors
    }

    private var defaultVendors: [Vendor] {
      // We assume that this vendor is always defined. It's a sensible default.
      return [Vendors.find("apple")!]
    }

    /**
     * Looks up which custom prefixes are specified.
     *
     * - returns: An Array of valid `MACPrefix`es or an empty Array if there are none.
     */
    var prefixes: [MACPrefix] {
      guard let rawPrefixes = dictionary["prefixes"] as? [String] else { return [] }

      let prefixes = rawPrefixes.compactMap { string -> MACPrefix? in
        let prefix = MACPrefix(string)
        return prefix.isValid ? prefix : nil
      }

      if (prefixes.isEmpty) { Log.debug("Currently no prefixes active")}
      return prefixes
    }

    /**
     * Gathers all default prefixes that can be used for randomization.
     *
     * - parameter hardMAC: The hardware MAC address of an Interface.
     *
     * - returns: An Array of valid `MacPrefix`es that is never empty.
     */
    var calculatedPrefixes: [MACPrefix] {
      let customPrefixes = prefixes
      let vendorPrefixes = vendors.flatMap { $0.prefixes }

      return customPrefixes + vendorPrefixes
    }

  }
}
