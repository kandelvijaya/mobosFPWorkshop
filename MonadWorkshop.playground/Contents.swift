import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

public final class NetworkService {

    public enum NetworkError: Error {
        case unknown
    }

    // Completion block here below is the actual work. Calling the completion of the completion block
    // might sound recursive but it isn't. This is how we build more complex closure; thus expression.
    public func get(from url: URL) -> Future<Result<Data>> {
        return Future { aCompletion in
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if let d = data, error == nil {
                    aCompletion?(.success(d))
                } else if let e = error {
                    aCompletion?(.failure(e))
                } else {
                    aCompletion?(.failure(NetworkError.unknown))
                }
            }
            dataTask.resume()
        }
    }

}



enum ServiceError: Error {
    case someError
    case dataConversionFailed
}

func getFromURL(_ url: URL, completion: @escaping ((Result<Data>) -> Void)) {
    URLSession.shared.dataTask(with: url) { (dataO, responseO, errorO) in
        if errorO == nil && dataO != nil {
            completion(.success(dataO!))
        } else {
            completion(.failure(ServiceError.someError))
        }
    }
}


let url = URL(string: "https://kandelvijaya.com/2017/05/28/fp-functor/")!

let data: Future<Result<Data>> = NetworkService().get(from: url)

func dataToString(_ data: Data) -> Result<String> {
    if let string = String(data: data, encoding: .utf8) {
        return .success(string)
    } else {
        return .failure(ServiceError.dataConversionFailed)
    }
}

func countOccuranceOfFunctor(_ string: String) -> Int {
    // do regexp here
    return 3
}

let y = data.then { $0.flatMap(dataToString) }

let z = y.then { $0.map(countOccuranceOfFunctor) }.then {
    print($0)
}


func extractURL(_ string: String) -> Result<URL> {
    return .success(URL(string: "www.objc.io")!)
}

let copiedY = y
let futureY = copiedY.then{ $0.flatMap(extractURL) }.bind {
    return NetworkService().get(from: URL(string: "www.objc.io")!)
}
futureY.then({ $0.flatMap(dataToString) }).then {
    print($0)
}


precedencegroup BindPrecedence {
    higherThan: BitwiseShiftPrecedence
    associativity: left
}
infix operator >>=: BindPrecedence

public func >>= <T,U>(_ lhs: Result<T>, _ rhsFunc: ((T) -> Result<U>)) -> Result<U> {
    return lhs.flatMap(rhsFunc)
}

let res12 = Result.success(12)

func addO(_ a: Int) -> Result<Int> {
    return .success(a + 12)
}

res12 >>= addO >>= addO






