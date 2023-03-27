//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var shows: [Show] = [Show]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UpcomingShowTableViewCell.self, forCellReuseIdentifier: UpcomingShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        setupTableView()
        fetchUpcoming()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let shows):
                self?.shows = shows
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("fetchUpcoming: \(error.localizedDescription)")
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowTableViewCell.identifier, for: indexPath) as?  UpcomingShowTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.textLabel?.text = shows[indexPath.row].original_title ?? shows[indexPath.row].original_name ?? "No name"
        let show = shows[indexPath.row]
        
        cell.configure(with: ShowViewModel(title: show.original_title ?? show.original_name ?? "Unknown", posterUrl: show.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
