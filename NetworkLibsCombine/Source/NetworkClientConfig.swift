import Foundation
public protocol NetworkClientConfig {
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
    var method: NetworkHTTPMethod { get }
    var url: URL? { get }
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy { get }
}
