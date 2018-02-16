//: Playground - noun: a place where people can play

import UIKit


func add(_ a: Int) -> (Int) -> Int {
    return { b in
        return a + b
    }
}


add(12)(13)




let x = Optional<Int>.some(3)
let xr = x.map(add)
