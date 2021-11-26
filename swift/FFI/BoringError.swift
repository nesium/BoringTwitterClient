import Boring
import Foundation
import os.log

public enum BoringError {
  case unexpected(message: String)
  case panic(message: String)
}

extension BoringError: LocalizedError, CustomStringConvertible {
  public var description: String {
    switch self {
    case let .unexpected(message):
      return "[unexpected] \(message)"
    case let .panic(message):
      return "[panic] \(message)"
    }
  }

  public var errorDescription: String? {
    return self.description
  }
}

extension BoringError {
  static func fromConsuming(_ rustError: BoringCoreError) -> BoringError? {
    let message = rustError.message

    switch rustError.code {
    case 0:
      return nil
    case -1:
      return .panic(message: String(freeingPlacesString: message!))
    default:
      return .unexpected(message: String(freeingPlacesString: message!))
    }
  }

  @discardableResult
  static func tryUnwrap<T>(
    _ callback: (UnsafeMutablePointer<BoringCoreError>) throws -> T?
  ) throws -> T? {
    var err = BoringCoreError(code: 0, message: nil)
    let returnedVal = try callback(&err)
    if let coreErr = BoringError.fromConsuming(err) {
      throw coreErr
    }
    guard let result = returnedVal else {
      return nil
    }
    return result
  }

  @discardableResult
  static func unwrap<T>(
    _ callback: (UnsafeMutablePointer<BoringCoreError>) throws -> T?
  ) throws -> T {
    guard let result = try BoringError.tryUnwrap(callback) else {
      throw ResultError.empty
    }
    return result
  }
}
