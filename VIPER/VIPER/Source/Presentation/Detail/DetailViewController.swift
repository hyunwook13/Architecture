//
//  DetailViewController.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit


protocol DetailViewInput {
    func setImage(_ image: UIImage)
    func configure(title: String, artist: String, info: String)
}

protocol DetailViewOutput {
    func viewDidLoad(with size: CGFloat)
    func tapSpotify()
}

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    var presenter: DetailViewOutput!
    
    // MARK: - UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private let artworkImageView: UIImageView = {
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
    
    private let spotifyButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = UIColor(red: 29/255, green: 185/255, blue: 84/255, alpha: 1)
        let spotifyImage = UIImage(named: "spotify")?.withRenderingMode(.alwaysTemplate)
        btn.setImage(spotifyImage, for: .normal)
        btn.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        setupLayout()
        
        presenter.viewDidLoad(with: view.bounds.width - 32)
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.axis = .vertical
        contentView.spacing = 16
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32)
        ])
        
        [artworkImageView, titleLabel, artistLabel, infoLabel].forEach {
            contentView.addArrangedSubview($0)
        }
        
        view.addSubview(spotifyButton)
        
        let buttonSize: CGFloat = 60
        NSLayoutConstraint.activate([
            spotifyButton.widthAnchor.constraint(equalToConstant: buttonSize),
            spotifyButton.heightAnchor.constraint(equalToConstant: buttonSize),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
        ])
        
        spotifyButton.layer.cornerRadius = buttonSize / 2
        spotifyButton.clipsToBounds = true
        
        spotifyButton.addTarget(self, action: #selector(didTapSpotify), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapSpotify() {
        presenter.tapSpotify()
    }
}

extension DetailViewController: DetailViewInput {
    func configure(title: String, artist: String, info: String) {
        titleLabel.text = title
        artistLabel.text = artist
        infoLabel.text = info
        self.title = title
    }
    
    func setImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.artworkImageView.image = image
        }
    }
}
