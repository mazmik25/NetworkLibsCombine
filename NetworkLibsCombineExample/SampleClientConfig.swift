import Foundation
import NetworkLibsCombine

enum Config {
    case getMovies(parameters: [String: Any])
}

extension Config: NetworkClientConfig {
    var parameters: [String : Any] {
        switch self {
        case .getMovies(let parameters): return parameters
        }
    }
    
    var headers: [String : String] {
        return [
            "Content-Type": "application/json",
            "accept": "application/json"
        ]
    }
    
    var method: NetworkHTTPMethod {
        return .GET
    }
    
    var url: URL? {
        return URL(string: "https://api.themoviedb.org/3/movie/now_playing")
    }
    
    var keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy {
        return .convertFromSnakeCase
    }
}
