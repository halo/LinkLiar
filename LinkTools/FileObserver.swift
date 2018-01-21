/*
 * Copyright (C) 2012-2018 halo https://io.github.com/halo/LinkLiar
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

  typealias FSEventStreamCallback = @convention(c) (ConstFSEventStreamRef, UnsafeMutableRawPointer?, Int, UnsafeMutableRawPointer, UnsafePointer<FSEventStreamEventFlags>, UnsafePointer<FSEventStreamEventId>) -> Void
  private let eventCallback: FSEventStreamCallback = { (stream, contextInfo, numEvents, eventPaths, eventFlags, eventIds) in

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
