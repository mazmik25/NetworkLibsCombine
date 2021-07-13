//
//  ViewController.swift
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

import UIKit
import NetworkLibsCombine

class ViewController: UIViewController {
    
    var items: [MoviesOutput] = []
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: "MovieCell")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }
    
    private func requestData() {
        let client: NetworkHTTPClient = NetworkHTTPClient<GetMoviesBodyResponse>(
            config: Config.getMovies(
                parameters: [
                    "api_key" : "API_KEY",
                    "page": 1
                ]
            )
        )
        
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
    }
}

extension ViewController: UITableViewDelegate,
                          UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
