//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    private var showEntities: [ShowEntity] = [ShowEntity]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(UpcomingShowTableViewCell.self, forCellReuseIdentifier: UpcomingShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        fetchDownloadedShow()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue: "Downloaded"), object: nil, queue: nil) { [weak self] _ in
            self?.fetchDownloadedShow()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchDownloadedShow() {
        CoreDataPersistenceManager.shared.fetchShowFromCoreData { [weak self] result in
            switch result {
            case .success(let data):
                self?.showEntities = data
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("fetchDownloadedShow: \(error.localizedDescription)")
            }
        }
    }

}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showEntities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowTableViewCell.identifier, for: indexPath) as?  UpcomingShowTableViewCell else {
            return UITableViewCell()
        }
        let show = showEntities[indexPath.row]
        
        cell.configure(with: ShowViewModel(title: show.original_title ?? "Unknown", posterUrl: show.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let show = showEntities[indexPath.row]
        let title = show.original_title ?? "No Title"
        
        APICaller.shared.searchYoutube(with: title) { [weak self] result in
            switch result {
            case .success(let item):
                DispatchQueue.main.async {
                    let vc = VideoPreviewViewController()
                    vc.configure(with: YoutubePreviewViewModel(title: title, youtubeVideo: item, overview: show.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("searchYoutube: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let show = showEntities[indexPath.row]
        
        switch editingStyle {
        case .none:
            break
        case .delete:
            CoreDataPersistenceManager.shared.deleteShowFromCoreData(with: show) { [weak self] result in
                switch result {
                case .success:
                    print("Deleted successfully")
                    self?.showEntities.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print("deleteShowFromCoreData: \(error.localizedDescription)")
                }
            }
        case .insert:
            break
        @unknown default:
            break
        }
    }
}
