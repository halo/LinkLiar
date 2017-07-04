import Foundation

struct  IntervalTimer {

  private static let interval: TimeInterval = 60 * 10
  private static let tolerance: TimeInterval = 60

  private static let timer: Timer = {
    let timer = Timer.scheduledTimer(withTimeInterval: IntervalTimer.interval, repeats: true, block: { _ in
      Log.debug("\(interval) seconds have passed.")
      NotificationCenter.default.post(name: .intervalElapsed, object: nil)
    })
    timer.tolerance = IntervalTimer.tolerance
    return timer
  }()

  static func run() {
    Log.debug("Activating interval timer every \(timer.timeInterval) seconds.")
  }
}

