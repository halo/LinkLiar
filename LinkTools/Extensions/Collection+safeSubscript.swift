// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

extension Collection {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}
