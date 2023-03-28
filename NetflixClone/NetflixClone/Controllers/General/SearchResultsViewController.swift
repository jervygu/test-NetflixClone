//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapItem(_ viewModel: YoutubePreviewViewModel)
}

class SearchResultsViewController: UIViewController {
    
    public var shows: [Show] = [Show]()
    
    weak var searchResultsViewControllerDelegate: SearchResultsViewControllerDelegate?
    
    public let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        
        
    }
    
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else { return UICollectionViewCell() }
//        cell.backgroundColor = .systemPink
        
        let show = shows[indexPath.row]
        cell.configure(with: show.poster_path ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        let title = show.original_title ?? show.original_name ?? ""
        
        APICaller.shared.searchYoutube(with: title) { [weak self] result in
            switch result {
            case .success(let item):
                self?.searchResultsViewControllerDelegate?.didTapItem(YoutubePreviewViewModel(
                    title: title,
                    youtubeVideo: item,
                    overview: show.overview ?? "Overview"))
            case .failure(let error):
                print("searchYoutube: \(error.localizedDescription)")
            }
        }
    }
    
}


//google api_key AIzaSyDMXVXPiZAphiQScMraw7XkGZKFVKK0S1U
