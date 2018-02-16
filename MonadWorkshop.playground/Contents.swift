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







