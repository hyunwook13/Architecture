//
//  AlbumCell.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

protocol AlbumCellDelegate: AnyObject {
    func albumCell(_ cell: AlbumCell, didToggleFavoriteFor albumID: String)
}

final class AlbumCell: UITableViewCell {
    static let reuseIdentifier = "AlbumCell"

    // MARK: - UI
    private let artworkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trackCountLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    // MARK: - State
    private var album: Album!
    private let placeholder = UIImage(systemName: "photo")!
    private var isFavorite = false {
        didSet { updateFavoriteUI() }
    }

    weak var delegate: AlbumCellDelegate?

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
        setupActions()
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }

    // MARK: - Public
    func configure(with album: Album, isFavorite: Bool) {
        self.album = album
        titleLabel.text = album.name
        subtitleLabel.text = album.artists.first?.name ?? "Unknown"
        trackCountLabel.text = "\(album.total_tracks) 곡"
        self.isFavorite = isFavorite
    }

    func setImage(_ image: UIImage?) {
        artworkImageView.image = image ?? placeholder
    }

    // MARK: - Private
    private func setupUI() {
        selectionStyle = .none
        contentView.backgroundColor = .clear

        // container style
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = .init(width: 0, height: 1)
        contentView.layer.shadowRadius = 4
        contentView.backgroundColor = .clear

        let bg = UIView()
        bg.backgroundColor = .white
        bg.layer.cornerRadius = 12
        bg.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(bg, at: 0)
        NSLayoutConstraint.activate([
            bg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])

        [artworkImageView, titleLabel, subtitleLabel, trackCountLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

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
        updateFavoriteUI()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
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
            trackCountLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }

    private func updateFavoriteUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func reset() {
        artworkImageView.image = placeholder
        titleLabel.text = nil
        subtitleLabel.text = nil
        trackCountLabel.text = nil
        isFavorite = false
        album = nil
    }

    @objc private func didTapFavorite() {
        guard let id = album?.id else { return }
        isFavorite.toggle()
        delegate?.albumCell(self, didToggleFavoriteFor: id)
    }
}
