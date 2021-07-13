import Foundation
public enum NetworkError: Error {
    case urlNotFound
    case responseNotFound
    case error(statusCode: Int)
    case failed(error: Error)
    case failedToDecoding(error: Error)
}
