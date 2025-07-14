//
//  AlbumCell.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

final class AlbumCell: UITableViewCell {
    static let reuseIdentifier = "AlbumCell"
    
    var presenter: AlbumCellPresenter?
    private let placeholder = UIImage(systemName: "photo")!
    
    private let baseView = UIView()
    private let artworkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trackCountLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    private var isFavorite = false {
        didSet { updateFavoriteUI() }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupStyle()
        setupActions()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        presenter = nil
        artworkImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        trackCountLabel.text = nil
        isFavorite = false
    }
    
    func configure(presenter: AlbumCellPresenter) {
        self.presenter = presenter
        presenter.viewDidLoad(self)
    }
    
    private func updateFavoriteUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    @objc private func didTapFavorite() {
        presenter?.tapFavorite()
    }
    
    private func setupStyle() {
        baseView.backgroundColor = .systemBackground
        baseView.layer.cornerRadius = 12
        baseView.layer.shadowColor = UIColor.black.cgColor
        baseView.layer.shadowOpacity = 0.1
        baseView.layer.shadowOffset = .init(width: 0, height: 1)
        baseView.layer.shadowRadius = 4
        selectionStyle = .none
        
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.clipsToBounds = true
        artworkImageView.layer.cornerRadius = 8
        artworkImageView.image = placeholder
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .darkGray
        trackCountLabel.font = .systemFont(ofSize: 12)
        trackCountLabel.textColor = .lightGray
        
        favoriteButton.tintColor = .systemRed
    }
    
    private func setupLayout() {
        contentView.addSubview(baseView)
        baseView.translatesAutoresizingMaskIntoConstraints = false
        
        [artworkImageView, titleLabel, subtitleLabel, trackCountLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            baseView.addSubview($0)
        }
        NSLayoutConstraint.activate([
            baseView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            baseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            baseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            baseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            
            artworkImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            artworkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: 60),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: artworkImageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: artworkImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -12),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            trackCountLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 2),
            trackCountLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            trackCountLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            trackCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}

extension AlbumCell: AlbumsCellViewInput {
    func reloadCell(_ res: Bool) {
        isFavorite = res
    }
    
    func configure(_ album: Album) {
        let subtitle = album.artists.map { $0.name }.joined(separator: ", ")
        
        titleLabel.text = album.name
        subtitleLabel.text = subtitle
        trackCountLabel.text = "\(album.total_tracks) 곡"
    }
    
    func setImage(_ img: UIImage) {
        DispatchQueue.main.async { [weak self] in 
            self?.artworkImageView.image = img
        }
    }
    
    func setFavorite(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}
