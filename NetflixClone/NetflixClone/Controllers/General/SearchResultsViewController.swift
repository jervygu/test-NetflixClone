//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    public var shows: [Show] = [Show]()
    
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
    
}

// https://youtube.com/watch?v=KCgYDCKqato&feature=shares&t=12040
