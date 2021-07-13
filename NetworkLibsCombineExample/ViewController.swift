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
                    "api_key" : "44755119354772a89e87cfd9ccef85f3",
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
