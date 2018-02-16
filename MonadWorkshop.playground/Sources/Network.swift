import Foundation

public final class Network {

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
