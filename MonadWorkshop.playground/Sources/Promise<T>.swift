import Foundation

public typealias Promise<T> = Future<T>

public struct Future<T> {

    public typealias Completion = (T) -> Void

    private var aTask: ((Completion?) -> Void)? = nil

    public init(_ task: @escaping ((Completion?) -> Void)) {
        self.aTask = task
    }

    public init(_ value: T) {
        self.aTask = { aCompletion in
            aCompletion?(value)
        }
    }

    @discardableResult public func then<U>(_ transform: @escaping (T) -> U) -> Future<U> {
        return Future<U>{ upcomingCompletion in
            self.aTask?() { tk in
                let transformed = transform(tk)
                upcomingCompletion?(transformed)
            }
        }
    }

    public func bind<U>(_ transform: @escaping (T) -> Future<U>) -> Future<U> {
        let transformed = then(transform)
        return Future.join(transformed)
    }

    static public func join<A>(_ input: Future<Future<A>>) -> Future<A> {
        return Future<A>{ aCompletion in
            input.then { innerPromise in
                innerPromise.then { innerValue in
                    aCompletion?(innerValue)
                    }.execute()
                }.execute()
        }
    }

    public func execute() {
        aTask?(nil)
    }

}
