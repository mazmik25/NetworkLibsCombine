# NetworkLibsCombine
Network utiliser using Combine and URLSession

## Prerequisites
- Requires iOS 13.0 and higher
- Swift 5.0

## Installation
### Cocoapods
```ruby
pod NetworkLibsCombine
```
### Carthage
- Create the `Cartfile`
```ruby
touch Cartfile && open -a Xcode Cartfile
```
- Next step is to add the dependency
```ruby
github "mazmik25/NetworkLibsCombine.git" "main"
```
- After that, you can run `carthage update`. If you don't have carthage, install it through Homebrew by running this line `brew install carthage`. **Disclaimer**: as you run `carthage update`, you will get the warnings. For now, just ignore them. It will be fixed later.
- Finally, you can add the dependency as a Framework.
<img width="971" alt="image" src="https://user-images.githubusercontent.com/25825451/125402309-74fe4d80-e3de-11eb-8725-d0c2bab88fe2.png">
And you're good to go!

### SPM
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
