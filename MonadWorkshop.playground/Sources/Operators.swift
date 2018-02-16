import Foundation

precedencegroup BindPrecedence {
    higherThan: BitwiseShiftPrecedence
    associativity: left
}
infix operator >>=: BindPrecedence

public func >>= <T,U>(_ lhs: Result<T>, _ rhsFunc: ((T) -> Result<U>)) -> Result<U> {
    switch lhs {
    case let  .failure(e):
        return .failure(e)
    case let .success(v):
        return rhsFunc(v)
    }
}


