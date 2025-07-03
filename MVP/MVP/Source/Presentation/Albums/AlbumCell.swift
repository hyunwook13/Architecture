//
//  AlbumCell.swift
//  MVP
//
//  Created by 이현욱 on 6/30/25.
//

protocol AlbumCellDelegate: AnyObject {
    func albumCell(didToggleFavoriteFor albumID: String)
}

//import UIKit
//
//final class AlbumCell: UITableViewCell {
//    static let reuseIdentifier = "AlbumCell"
//
//    private let cellView = AlbumCellView()
//    weak var delegate: AlbumCellDelegate?
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setup()
//        setAction()
//    }
//
//    required init?(coder: NSCoder) { fatalError() }
//
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        cellView.reset()
//    }
//
//    func configure(with album: Album, isFavorite: Bool) {
//        cellView.configure(with: album, isFavorite: isFavorite)
//    }
//
//    func setImage(_ image: UIImage) {
//        cellView.setImage(image)
//    }
//
//    private func setup() {
//        contentView.addSubview(cellView)
//        cellView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
//            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
//        ])
//
//        cellView.backgroundColor = .systemBackground
//        cellView.layer.cornerRadius = 12
//        cellView.layer.shadowColor = UIColor.black.cgColor
//        cellView.layer.shadowOpacity = 0.1
//        cellView.layer.shadowOffset = .init(width: 0, height: 1)
//        cellView.layer.shadowRadius = 4
//        selectionStyle = .none
//    }
//
//    private func setAction() {
//        cellView.favoriteToggled = {
//            self.delegate?.albumCell(self, didToggleFavoriteFor: $0)
//        }
//    }
//}

import UIKit

//protocol AlbumCellDelegate: AnyObject {
//    func albumCell(_ cell: AlbumCell, didToggleFavoriteFor albumID: String)
//}

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
    
    private func updateFavoriteUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func setupActions() {
        favoriteButton.addTarget(self, action: #selector(didTapFavorite), for: .touchUpInside)
    }
    
    @objc private func didTapFavorite() {
        isFavorite.toggle()
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

extension AlbumCell: AlbumCellView {
    func configure(title: String, artist: [Artist], trackCount: Int, isFavorite: Bool) {
        let subtitle = artist.map(\.name).joined(separator: ", ")
        self.isFavorite = isFavorite
        titleLabel.text = title
        subtitleLabel.text = subtitle
        trackCountLabel.text = "\(trackCount) 곡"
    }
    
    func setImage(_ image: UIImage?) {
        artworkImageView.image = image ?? placeholder
    }
}
