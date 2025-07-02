//
//  AlbumCellView.swift
//  MVC
//
//  Created by 이현욱 on 7/1/25.
//

import UIKit

final class AlbumCellView: UIView {
    
    private var album: Album!
    
    // MARK: - Subviews
    let artworkImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let trackCountLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    // MARK: - State & Callback
    private var isFavorite = false {
        didSet { updateFavoriteUI() }
    }
    /// 즐겨찾기 상태가 바뀔 때 호출
    var favoriteToggled: ((String) -> Void)?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        style()
        setupActions()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Styling
    private func style() {
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.clipsToBounds = true
        artworkImageView.layer.cornerRadius = 8
        
        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .darkGray
        trackCountLabel.font = .systemFont(ofSize: 12)
        trackCountLabel.textColor = .lightGray
        
        favoriteButton.tintColor = .systemRed
        updateFavoriteUI()
    }
    
    private func updateFavoriteUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    // MARK: - Layout
    private func setupLayout() {
        [artworkImageView, titleLabel, subtitleLabel, trackCountLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            artworkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            artworkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            artworkImageView.widthAnchor.constraint(equalToConstant: 60),
            artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor),

            favoriteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
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
            trackCountLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }

    // MARK: - Actions
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }

    @objc private func didTapFavorite() {
        isFavorite.toggle()
        favoriteToggled?(album.id)
    }

    // MARK: - Configuration
    func configure(with album: Album, isFavorite: Bool) {
        self.album = album
        titleLabel.text = album.name
        subtitleLabel.text = album.artists.first?.name ?? "Unknown"
        trackCountLabel.text = "\(album.total_tracks) 곡"
        self.isFavorite = isFavorite         // 초기 상태 반영
        Task {
            let img = await APIClient.shared.getImage(with: album.images.first?.url)
            DispatchQueue.main.async { self.artworkImageView.image = img }
        }
    }
}
