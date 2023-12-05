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

