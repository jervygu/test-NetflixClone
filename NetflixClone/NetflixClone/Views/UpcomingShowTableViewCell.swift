//
//  UpcomingShowTableViewCell.swift
//  NetflixClone
//
//  Created by Jeff Umandap on 3/27/23.
//

import UIKit

class UpcomingShowTableViewCell: UITableViewCell {
    static let identifier = "UpcomingShowTableViewCell"
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        button.tintColor = .label
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    public func configure(with model: ShowViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterUrl)") else { return }
        
        posterImageView.sd_setImage(with: url)
        titleLabel.text = model.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
