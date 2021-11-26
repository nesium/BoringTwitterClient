import Boring
import Foundation

extension Data {
  init(buffer: BoringBuffer) {
    defer { boring_core_destroy_boring_buffer(buffer) }
    self.init(bytes: buffer.data!, count: Int(buffer.len))
  }
}
