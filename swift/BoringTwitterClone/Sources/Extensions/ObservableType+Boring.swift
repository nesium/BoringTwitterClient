import RxSwift

public extension ObservableType {
  func filterNil<T>() -> Observable<T> where Element == Optional<T> {
    return self.filter { $0 != nil }.map { $0! }
  }
}
