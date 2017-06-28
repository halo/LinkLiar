
// See https://blog.beecomedigital.com/2015/06/27/developing-a-filesystemwatcher-for-os-x-by-using-fsevents-with-swift-2/
// See https://gist.github.com/DivineDominion/56e56f3db43216d9eaab300d3b9f049a

import Foundation

public class FileObserver {

  let callback: () -> Void

  public init(path: String, sinceWhen: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow), callback: @escaping () -> Void) {

    self.lastEventId = sinceWhen
    self.pathsToWatch = [path]
    self.callback = callback
    start()
  }

  deinit {
    stop()
  }

  // MARK: - Private Properties

  private let eventCallback: FSEventStreamCallback = { (stream: ConstFSEventStreamRef, contextInfo: UnsafeMutableRawPointer?, numEvents: Int, eventPaths: UnsafeMutableRawPointer, eventFlags: UnsafePointer<FSEventStreamEventFlags>?, eventIds: UnsafePointer<FSEventStreamEventId>?) in

    let fileSystemWatcher: FileObserver = unsafeBitCast(contextInfo, to: FileObserver.self)
    let paths = unsafeBitCast(eventPaths, to: NSArray.self) as! [String]

    for index in 0..<numEvents {
      fileSystemWatcher.processEvent(eventId: eventIds![index], eventPath: paths[index], eventFlags: eventFlags![index])
    }

    fileSystemWatcher.lastEventId = eventIds![numEvents - 1]
  }

  private let pathsToWatch: [String]
  private var started = false
  private var streamRef: FSEventStreamRef!

  private func processEvent(eventId: FSEventStreamEventId, eventPath: String, eventFlags: FSEventStreamEventFlags) {
    callback()
  }

  public private(set) var lastEventId: FSEventStreamEventId

  public func start() {
    guard started == false else { return }

    var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    context.info = Unmanaged.passUnretained(self).toOpaque()
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    streamRef = FSEventStreamCreate(kCFAllocatorDefault, eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)

    FSEventStreamScheduleWithRunLoop(streamRef, CFRunLoopGetMain(), CFRunLoopMode.defaultMode.rawValue)
    FSEventStreamStart(streamRef)

    started = true
  }

  public func stop() {
    guard started == true else { return }

    FSEventStreamStop(streamRef)
    FSEventStreamInvalidate(streamRef)
    FSEventStreamRelease(streamRef)
    streamRef = nil

    started = false
  }
}
