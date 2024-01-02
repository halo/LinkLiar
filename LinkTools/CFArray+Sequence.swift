// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

extension CFArray: Sequence {

  /// Just a little helper to loop through a CFArray.
  /// Kindly provided by http://stackoverflow.com/a/32127187
  public func makeIterator() -> AnyIterator<AnyObject> {
    var index = -1
    let maxIndex = CFArrayGetCount(self)
    return AnyIterator {
      index += 1
      guard index < maxIndex else {
        return nil
      }
      let unmanagedObject: UnsafeRawPointer = CFArrayGetValueAtIndex(self, index)
      return unsafeBitCast(unmanagedObject, to: AnyObject.self)
    }
  }

}
