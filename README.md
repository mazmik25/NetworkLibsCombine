# NetworkLibsCombine
Network utiliser using Combine and URLSession

## Prerequisites
- Requires iOS 13.0 and higher
- Swift 5.0

## Installation
Cocoapods
```ruby
pod NetworkLibsCombine
```
SPM
```ruby
# Copy this to your SPM dependecies 
https://github.com/mazmik25/NetworkLibsCombine.git
``` 

## Usage
First of all, you need to setup your HTTP client. It's all available by subclassing `NetworkClientConfig`
```swift
import NetworkLibsCombine

// I prefer enum since this is much easier to use
// You can also use struct
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
```
And just call the request by calling `NetworkHTTPClient.request(completion:)`
```swift
  ...
    let client: NetworkHTTPClient = NetworkHTTPClient<GetMoviesBodyResponse>(
        config: Config.getMovies(
            parameters: [
                "api_key" : "API_KEY",
                "page": 1
            ]
        ))

    client.request { [weak self] result in
        guard let self = self else { return }
        switch result {
            case .success(let response):
            self.items = response.results.compactMap {
                let output: MoviesOutput = MoviesOutput(
                    title: $0.title,
                    synopsis: $0.overview,
                    posterPath: $0.posterPath
                )
            
                print(output.description)
                return output
            }
            self.tableView.reloadData()
            case .failure(let error): print(error)
        }
    }
  ...
```
**And that's it!** For more details, you can check the example [here](https://github.com/mazmik25/NetworkLibsCombine/tree/main/NetworkLibsCombineExample)
