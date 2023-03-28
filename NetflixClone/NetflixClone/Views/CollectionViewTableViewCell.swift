//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func didTapCell(_ cell: CollectionViewTableViewCell, viewModel: YoutubePreviewViewModel)
}
 
class CollectionViewTableViewCell: UITableViewCell {
    static let identifier = "CollectionViewTableViewCell"
    
    weak var collectionViewTableViewCellDelegate: CollectionViewTableViewCellDelegate?
    
    private var shows: [Show] = [Show]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
        collectionViewSetup()
    }
    
    func collectionViewSetup() {
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with shows: [Show]) {
        self.shows = shows
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadItemAt(indexPath: IndexPath) {
        print("Downloading: \(shows[indexPath.row].original_title)")
        let show = shows[indexPath.row]
        CoreDataPersistenceManager.shared.downloadShow(with: show) { result in
            switch result {
            case .success(let data):
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "Downloaded"), object: nil, userInfo: nil))
            case .failure(let error):
                print("downloadItem: \(error.localizedDescription)")
            }
        }
    }
    
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
//        cell.backgroundColor = .systemGreen
        if let posterPath = shows[indexPath.row].poster_path {
            cell.configure(with: posterPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let show = shows[indexPath.row]
        guard let title = show.original_title ?? show.original_name ?? show.name else { return }
        
        // https://www.youtube.com/watch?v=yjRHZEUamCc
        
        APICaller.shared.searchYoutube(with: "\(title) trailer") { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
//                print("searchYoutube", data)
                let viewModel = YoutubePreviewViewModel(
                    title: title,
                    youtubeVideo: data,
                    overview: show.overview ?? "")
                
                self.collectionViewTableViewCellDelegate?.didTapCell(self, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @available(iOS 15.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    
                    self.downloadItemAt(indexPath: indexPaths.first!)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
}
