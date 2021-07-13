//
//  NetworkHTTPClient.swift
//
//  MIT License
//
//  Copyright (c) 2021 Azmi Muhammad
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import Combine

public final class NetworkHTTPClient<Element: Codable> {
    
    private let config: NetworkClientConfig
    private var cancelable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    public init(config: NetworkClientConfig) {
        self.config = config
    }
    
    public func request(completion: @escaping (Result<Element, Error>) -> Void) {
        if let publisher: AnyPublisher<Element, Error> = setupPublisher() {
            publisher
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { event in
                    switch event {
                    case .failure(let error): completion(.failure(NetworkError.failed(error: error)))
                    default: break
                    }
                }, receiveValue: { element in
                    completion(.success(element))
                }).store(in: &cancelable)
        } else {
            completion(.failure(NetworkError.urlNotFound))
        }
    }
      
    private func setupPublisher() -> AnyPublisher<Element, Error>? {
        if let url: URL = config.url {
            let decoder: JSONDecoder = JSONDecoder()
            decoder.keyDecodingStrategy = config.keyDecodingStrategy
            return setupSession().dataTaskPublisher(for: setupRequest(withURL: url))
                .tryMap { result -> Data in
                    guard let httpResponse: HTTPURLResponse = result.response as? HTTPURLResponse,
                       200..<300 ~= httpResponse.statusCode else {
                        throw NetworkError.error(statusCode: (result.response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return result.data
                }
                .decode(type: Element.self, decoder: decoder)
                .catch { error in Fail(error: NetworkError.failedToDecoding(error: error)).eraseToAnyPublisher() }
                .eraseToAnyPublisher()
        } else { return nil }
    }
      
    private func setupSession() -> URLSession {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let session: URLSession = URLSession(configuration: configuration)
        return session
    }
    
    private func setupRequest(withURL url: URL) -> URLRequest {
        var request: URLRequest
        switch config.method {
        case .GET:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            var queryItems: [URLQueryItem] = []
            for key in config.parameters.keys {
                queryItems.append(URLQueryItem(name: key, value: "\(config.parameters[key]!)"))
            }
            urlComponents.queryItems = queryItems
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            request = URLRequest(url: urlComponents.url!)
        default:
            request = URLRequest(url: url)
            do {
                let httpBody: Data = try JSONSerialization.data(withJSONObject: config.parameters)
                request.httpBody = httpBody
            } catch {
                print(error)
            }
        }
        
        request.httpMethod = config.method.rawValue
        config.headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        return request
    }
}
