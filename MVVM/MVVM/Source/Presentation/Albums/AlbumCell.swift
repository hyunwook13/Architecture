//
//  AlbumCell.swift
//  MVVM
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol AlbumCellDelegate: AnyObject {
    func albumCell(didToggleFavoriteFor albumID: String)
}

final class AlbumCell: UITableViewCell {
    static let reuseIdentifier = "AlbumCell"
    private var disposeBag = DisposeBag()
    private var vm: AlbumCellModelType?
    
    private var album: Album!
    private var isFavorite = false {
        didSet { updateFavoriteUI() }
    }
    
    private let placeholder = UIImage(systemName: "photo")!
    
    // MARK: - Subviews
    private let artworkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trackCountLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        cellStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artworkImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        trackCountLabel.text = nil
        vm = nil
        isFavorite = false
        disposeBag = DisposeBag()
    }
    
    // MARK: - Public API
    func configure(with album: Album, isFavorite: Bool) {
        self.album = album
        self.isFavorite = isFavorite
        titleLabel.text = album.name
        subtitleLabel.text = album.artists.first?.name ?? "Unknown"
        trackCountLabel.text = "\(album.total_tracks) 곡"
        print(isFavorite)
    }
    
    func setImage(_ image: UIImage) {
        artworkImageView.image = image
    }
    
    func setting(with vm: AlbumCellModelType) {
        self.vm = vm
        bind()
    }
    
    // MARK: - Private
    private func updateFavoriteUI() {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    private func bind() {
        favoriteButton.rx.tap
            .withUnretained(self)
            .flatMap { _ in
                self.isFavorite.toggle()
                return Observable.of(self.album.id)
            }
            .bind(to: vm!.input.selectedLike)
            .disposed(by: disposeBag)
    }
    
    private func cellStyle() {
        backgroundColor = .clear
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
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 4
    }
    
    private func setupLayout() {
        [artworkImageView, titleLabel, subtitleLabel, trackCountLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
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
            trackCountLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
}
