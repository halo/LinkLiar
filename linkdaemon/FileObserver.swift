import Cocoa

class FileObserver {

  private let fileDescriptor: CInt
  private let source: DispatchSourceProtocol

  init(path: String, block: @escaping ()->Void) {
    self.fileDescriptor = open(path, O_EVTONLY)
    self.source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: self.fileDescriptor, eventMask: .all, queue: DispatchQueue.global())
    self.source.setEventHandler {
      block()
    }
    self.source.resume()
  }

  deinit {
    self.source.cancel()
    close(fileDescriptor)
  }
}
