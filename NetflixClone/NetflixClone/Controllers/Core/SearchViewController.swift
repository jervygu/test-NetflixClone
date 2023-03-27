//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var shows: [Show] = [Show]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UpcomingShowTableViewCell.self, forCellReuseIdentifier: UpcomingShowTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search here..."
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Search"
        
        setupNavigationBar()
        setupTableView()
        fetchData()
        setupSearchController()
        
    }
    
    private func fetchData() {
        APICaller.shared.discoverMovies { [weak self] result in
            switch result {
            case .success(let shows):
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("discoverMovies: \(error.localizedDescription)")
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        
    }
    
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
        
        APICaller.shared.searchShow(with: query) { results in
            switch results {
            case .success(let shows):
                DispatchQueue.main.async {
                    resultsController.shows = shows
                    resultsController.collectionView.reloadData()
                }
            case .failure(let error):
                print("searchShow: \(error.localizedDescription)")
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowTableViewCell.identifier, for: indexPath) as?  UpcomingShowTableViewCell else {
            return UITableViewCell()
        }
        
        let show = shows[indexPath.row]
        cell.configure(with: ShowViewModel(title: show.original_title ?? show.original_name ?? "", posterUrl: show.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
