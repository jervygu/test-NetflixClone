//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

enum HomeSections: Int {
    case TrendingMovies = 0
    case TrendingTvs = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    private var randomTrendingMovie: Show?
    private var headerView: HeroHeaderView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupTableView()
        configHeaderView()
        
//        fetchData()
    }
    
//    private func fetchData() {
//        APICaller.shared.getTrendingMovies { results in
//            switch results {
//            case .success(let data):
////                print(data)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        APICaller.shared.getTrendingTvs { results in
//            switch results {
//            case .success(let data):
////                print(data)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        APICaller.shared.getPopularMovies { results in
//            switch results {
//            case .success(let data):
////                print("getPopularMovies", data)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        APICaller.shared.getUpcomingMovies { results in
//            switch results {
//            case .success(let data):
////                print(data)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//        APICaller.shared.getTopRatedMovies { results in
//            switch results {
//            case .success(let data):
////                print("getTopRatedMovies", data)
//                break
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
    func setupTableView() {
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
    }
     
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
        
        configureNavBar()
        
//        homeFeedTable.tableHeaderView = UIView(frame: CGRect(
//            x: 0,
//            y: 0,
//            width: view.bounds.width,
//            height: 400))
        headerView = HeroHeaderView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.bounds.width,
            height: 400))
        homeFeedTable.tableHeaderView = headerView
    }
    
    private func configHeaderView() {
        APICaller.shared.getTrendingTvs { [weak self] result in
            switch result {
            case .success(let show):
                let randomShow = show.randomElement()
                self?.randomTrendingMovie = randomShow
                self?.headerView?.configure(with: ShowViewModel(
                    title: randomShow?.original_title ?? randomShow?.original_name ?? "",
                    posterUrl: randomShow?.poster_path ?? ""))
            case .failure(let error):
                print("getTrendingTvs: \(error.localizedDescription)")
            }
        }
    }
    
    private func configureNavBar() {
        var image = UIImage(named: "netflix_logo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil),
        ]
        
        navigationController?.navigationBar.tintColor = .label
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
//        cell.textLabel?.text = "try \(indexPath.row)"
        
        cell.collectionViewTableViewCellDelegate = self
        
        switch indexPath.section {
        case HomeSections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results {
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let error):
                    print("TrendingMovies: \(error.localizedDescription)")
                }
            }
        case HomeSections.TrendingTvs.rawValue:
            APICaller.shared.getTrendingTvs { results in
                switch results {
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let error):
                    print("TrendingTvs: \(error.localizedDescription)")
                }
            }
        case HomeSections.Popular.rawValue:
            APICaller.shared.getPopularMovies { results in
                switch results {
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let error):
                    print("Popular: \(error.localizedDescription)")
                }
            }
        case HomeSections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                switch results {
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let error):
                    print("Upcoming: \(error.localizedDescription)")
                }
            }
        case HomeSections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { results in
                switch results {
                case .success(let shows):
                    cell.configure(with: shows)
                case .failure(let error):
                    print("TopRated: \(error.localizedDescription)")
                }
            }
        default:
            return UITableViewCell()
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(
            x: header.bounds.origin.x + 20,
            y: header.bounds.origin.y,
            width: 100,
            height: header.bounds.height)
        header.textLabel?.textColor = .label
        header.textLabel?.text = header.textLabel?.text?.capitalizedFirstLetter()
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scroll with navigation bar
        let defaultOffset = view.safeAreaInsets.top
        let offSet = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offSet))
    }
    
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: YoutubePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = VideoPreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
