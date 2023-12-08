// Copyright (c) halo https://github.com/halo/LinkLiar
// SPDX-License-Identifier: MIT


import Foundation

// See https://gist.github.com/DivineDominion/56e56f3db43216d9eaab300d3b9f049a
public class FileObserver {

  // MARK: Class Methods

  init(path: String, callback: @escaping () -> Void) {

    self.lastEventId = sinceWhen
    self.pathsToWatch = [path]
    self.callback = callback
    start()
  }

  // MARK: Instance Methods

  public func start() {
    guard started == false else { return }

    var context = FSEventStreamContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    context.info = Unmanaged.passUnretained(self).toOpaque()
    let flags = UInt32(kFSEventStreamCreateFlagUseCFTypes | kFSEventStreamCreateFlagFileEvents)
    streamRef = FSEventStreamCreate(kCFAllocatorDefault,
                                    eventCallback, &context, pathsToWatch as CFArray, lastEventId, 0, flags)

    FSEventStreamSetDispatchQueue(streamRef, queue)
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

  let callback: () -> Void
  let queue: DispatchQueue = DispatchQueue(label: "io.github.halo.LinkLiar.fileObserverQueue")

//
//  deinit {
//    stop()
//  }

  // MARK: - Private Properties

  public private(set) var sinceWhen: FSEventStreamEventId = FSEventStreamEventId(kFSEventStreamEventIdSinceNow)

  typealias FSEventStreamCallback = @convention(c) (ConstFSEventStreamRef,
                                                    UnsafeMutableRawPointer?, Int,
                                                    UnsafeMutableRawPointer,
                                                    UnsafePointer<FSEventStreamEventFlags>,
                                                    UnsafePointer<FSEventStreamEventId>) -> Void
  private let eventCallback: FSEventStreamCallback = { (_, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in

    let fileSystemWatcher: FileObserver = unsafeBitCast(contextInfo, to: FileObserver.self)
    guard let paths = unsafeBitCast(eventPaths, to: NSArray.self) as? [String] else { return }

    for index in 0..<numEvents {
      fileSystemWatcher.processEvent(eventId: eventIds[index], eventPath: paths[index], eventFlags: eventFlags[index])
    }

    fileSystemWatcher.lastEventId = eventIds[numEvents - 1]
  }

  private let pathsToWatch: [String]
  private var started = false
  private var streamRef: FSEventStreamRef!

  private func processEvent(eventId: FSEventStreamEventId, eventPath: String, eventFlags: FSEventStreamEventFlags) {
    callback()
  }

  public private(set) var lastEventId: FSEventStreamEventId

}
