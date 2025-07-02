//
//  DetailView.swift
//  MVC
//
//  Created by 이현욱 on 7/1/25.
//

import UIKit

final class DetailView: UIView {
    
    var playAlbumTap: (() -> Void)?
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    let artworkImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 24)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .gray
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Spotify 스타일 버튼
    private let spotifyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 29/255, green: 185/255, blue: 84/255, alpha: 1)
        let spotifyImage = UIImage(named: "spotify")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(spotifyImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
        setupActions()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Layout
    private func setupLayout() {
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
        // 순서대로 추가
        [artworkImageView, titleLabel, artistLabel, infoLabel].forEach {
            contentView.addArrangedSubview($0)
        }
        
        self.addSubview(spotifyButton)
        
        // 버튼 크기 설정 (고정 60pt)
        let buttonSize: CGFloat = 60
        NSLayoutConstraint.activate([
            spotifyButton.widthAnchor.constraint(equalToConstant: buttonSize),
            spotifyButton.heightAnchor.constraint(equalToConstant: buttonSize),
            spotifyButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            spotifyButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
        ])
        spotifyButton.layer.cornerRadius = buttonSize / 2
        spotifyButton.clipsToBounds = true
    }
    
    // MARK: - Actions
    private func setupActions() {
        spotifyButton.addTarget(self, action: #selector(didTapSpotify), for: .touchUpInside)
    }
    
    @objc private func didTapSpotify() {
        playAlbumTap?()
    }
    
    // MARK: - Configuration
    func configure(title: String, artist: String, info: String) {
        titleLabel.text = title
        artistLabel.text = artist
        infoLabel.text = info
    }
    
    func setImage(_ image: UIImage?) {
        artworkImageView.image = image
    }
}
