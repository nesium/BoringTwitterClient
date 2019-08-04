import Lists
import NSMFoundation

// MARK: - Types -

enum SelectableEntity {
  case post(Boring_Types_Post)
  case author(Int64)
  case email(String)
}

enum FutureType<T: Diffable> {
  case loading
  case error(Error)
  case result(T)
}

extension FutureType {
  var result: T? {
    if case let .result(result) = self {
      return result
    }
    return nil
  }
}

// MARK: - Diffing -

protocol Diffable: Equatable {
  var diffIdentifier: String { get }
}

// The diffWitnesses are used to provide an identity for objects. When the contents of a list are
// modified, cells whose underlying objects, which might not be equal but share the same diff
// identity, will be updated instead of replaced.
func diff<T: Diffable>() -> Diffing<T> {
  return Diffing<T>(
    identifier: { $0.diffIdentifier },
    equals: ==
  )
}

extension Boring_Types_Post: Diffable {
  var diffIdentifier: String {
    return String(self.id)
  }
}

extension Boring_Types_Comment: Diffable {
  var diffIdentifier: String {
    return String(self.id)
  }
}

extension FutureType: Diffable {
  var diffIdentifier: String {
    switch self {
      case .loading:
        return "loading"
      case .error:
        return "error"
      case let .result(result):
        return result.diffIdentifier
    }
  }

  static func ==(lhs: FutureType, rhs: FutureType) -> Bool {
    switch (lhs, rhs) {
      case (.loading, .loading):
        return true
      case let (.error(e1), .error(e2)):
        return e1.localizedDescription == e2.localizedDescription
      case let (.result(r1), .result(r2)):
        return r1 == r2
      case (.loading, _), (.error, _), (.result, _):
        return false
    }
  }
}

extension Either: Diffable where L: Diffable, R: Diffable {
  var diffIdentifier: String {
    switch self {
      case let .left(left):
        return left.diffIdentifier
      case let .right(right):
        return right.diffIdentifier
    }
  }
}
