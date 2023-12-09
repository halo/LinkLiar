// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT

import Foundation

class IntervalTimer {
  // MARK: Class Methods

  init(callback: @escaping () -> Void) {
    self.callback = callback
    start()
  }

  // MARK: Instance Methods

  private func start() {
    guard started == false else { return }

    started = true
  }

  // MARK: - Private Properties

  private var started = false
  private let callback: () -> Void

  private let timer: Timer = {
    let interval: TimeInterval = 60 * 10

    let newTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { _ in
      Log.debug("\(interval) seconds have passed.")
      NotificationCenter.default.post(name: .intervalElapsed, object: nil)
    })
    newTimer.tolerance = 60

    return newTimer
  }()
}
