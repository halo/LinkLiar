//import Foundation
//
//func main() {
//    while true {
//        print("Hello World!")
//        sleep(3)
//    }
//}
//
//main()



import Foundation

ConfigDirectory.create()

let data = "Hello 1 the World!\n".data(using: .utf8)!

if let fileHandle = FileHandle(forWritingAtPath: "/tmp/linkliar.log") {
  defer {
    fileHandle.closeFile()
  }
  fileHandle.seekToEndOfFile()
  fileHandle.write(data)
} else {
  try "Initializing...".write(toFile: "/tmp/linkliar.log", atomically: true, encoding: .utf8)
}

func main() {
  for _ in 1...3 {

      
      let data = "Ping\n".data(using: .utf8)!

      if let fileHandle = FileHandle(forWritingAtPath: "/tmp/linkliar.log") {
        defer {
          fileHandle.closeFile()
        }
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
      }
      
    
    
      sleep(1)
    }
  
  
  let data = "Bye!\n".data(using: .utf8)!

  if let fileHandle = FileHandle(forWritingAtPath: "/tmp/linkliar.log") {
    defer {
      fileHandle.closeFile()
    }
    fileHandle.seekToEndOfFile()
    fileHandle.write(data)
  }
  exit(99)
}

main()
////print("Hello World from daemon!")
////
////Log.debug("Hello, World from daemon!")
////
////ConfigDirectory.create()
////
////print("Bye from daemon!")
