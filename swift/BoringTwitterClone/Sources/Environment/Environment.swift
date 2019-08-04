import Foundation

// This feels so wrong, but makes things quite easy.
// Learn more at https://www.pointfree.co/episodes/ep16-dependency-injection-made-easy

struct Environment {
  var ffi: FFI
  var theme: Theme
}

var Current: Environment = {
  let dbURL = FileManager.default.urls(
    for: .documentDirectory, in: .userDomainMask
  ).first!.appendingPathComponent("cache.sqlite")

  return Environment(
    ffi: try! FFI(dbURL: dbURL),
    theme: Theme()
  )
}()
