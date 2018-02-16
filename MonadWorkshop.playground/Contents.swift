//: Playground - noun: a place where people can play

import UIKit

let res1 = Result.success(1)


// Every function in FP is based on Lambda calculus.
// According to it, a function takes 1 input and must
// 1 output and nothing else.
// print() is not a pure function
// viewDidLoad() too is not a pure function

// 1. currying function to act as if it takes 2 parameters
// This allows for partial application
func add(_ a: Int) -> (Int) -> Int {
    return { b in
        return a + b
    }
}


// Simple functions
func mult5(_ a: Int) -> Int {
    return a * 5
}

func mult(_ a: Int, _ b: Int) -> Int {
    return a + b
}



// Functor
// Anything that is mappable
// A functor has to map from the same kind
// Result<T> map should produce Result<U> but not [U]
// although [U] is a functor (list functor)


// map : (a -> b) -> Functor a -> Functor b
//
// func map(_ transform: (A -> B), on: Functor<A>) -> Functor<B>






// functor on fire
// What if a computation produces a functor with a partial function inside
// say Result.success(add) :: Result<(Int) -> Int>
// And we have another Result with concrete value
// say Result.success(13)
//
// Q: can i take internal function from Result.success(add) and map it over Result.success(13)
//
// We can do manual unwrap and pass but we are aimig for a general fundamental solutoin?
//


// res1.map(mult(<#T##a: Int##Int#>, <#T##b: Int##Int#>)) doesnot work
let output = res1.map(add)

// Result<Int>.success(FUNCTION)
// A function is stuck inside a box. How can we make use of it?


//Soln 1
switch output {
case let .success(f):
    f(13)
case let .failure(e):
    print(e)
}


// Soln2
output.map { (partial) -> Int in
    return partial(13)
}


// What if we have a Result.success(add) and Result.success(13)
// how do we compose

let res2 = res1.map({ $0 + 1 })
let res3 = res1.map({ $0 + 2 })


// Soln3 :: The applicative functor
func applic<T,U>(_ first: Result<((T) -> U)>, with second: Result<T>) -> Result<U> {
    switch first {
    case let .success(firstFunction):
        let applicated = second.map(firstFunction)
        return applicated
    case let .failure(e):
        return .failure(e)
    }
}


let boxedFunctionResult = Result.success(add(12))
applic(boxedFunctionResult, with: Result.success(13))



// map    :: (A -> B)           -> Functor A -> Functor B
// applic :: Functor (A -> B)   -> Functor A -> Functor B


// add3 :: Int -> Int -> Int -> Int
func add3(_ a: Int) -> (Int) -> (Int) -> Int {
    return { b in
        return { c in
            return a + b + c
        }
    }
}



let partialResult3 = Result.success(add3)

let level1Applic = Result.applic(partialResult3, onFunctor: Result.success(12))
let level2Applic = Result.applic(level1Applic, onFunctor: Result.success(13))
let level3Applic = Result.applic(level2Applic, onFunctor: Result.success(14))








/// 3. Monad
/// Computation with Context
/// Result<Int> means there might be a result or error
/// Optional<Wrapped> means there might be something or nothing
/// So whats the fuss?
/// Back to composing simple functions:

/// Say we have Functor<A> and we have another function that
/// takes a concrete value and returns Functor
/// i.e. A -> Functor<B>
/// How can we compose these without losing context?

// bind :: F<A> -> (A -> F<B>) -> F<B>
// bind :: M<A> -> (A -> M<B>) -> M<B> where M represents Monad
// Remeber we need to presver context as we compose!!


/// Just to recap:
/// Functor dealt with mapping      (A -> B) -> F<A> -> F<B>
/// Applicative dealth with        F(A -> B) -> F<A> -> F<B>
/// Monad deals with               (A -> F<B>) -> F<A> -> F<B>
///
/// Interesting to note            (B -> F<A>) -> F<A> -> F<B>
/// is a function we didnt talk. Its because types dont align and there
/// is no direct composition.
/// Note in monad the order of transform and context is reversed in haskell.



// Partial fmap
func fmap<U,V>(_ transform: @escaping ((U) -> V)) -> (Result<U>) -> Result<V> {
    return { b in
        return b.map(transform)
    }
}

let partialFmap = fmap(mult5)
partialFmap(Result.success(5))















