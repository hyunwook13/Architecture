//
//  DetailViewController.swift
//  MVP
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

protocol DetailView {
    func configure(with title: String, artist: String, info: String)
    func setImage(_ img: UIImage)
}

final class DetailViewController: UIViewController {
    
    var presenter: DetailPresenter?
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let artworkImageView = UIImageView()
    private let titleLabel = UILabel()
    private let artistLabel = UILabel()
    private let infoLabel = UILabel()
    private let spotifyButton = UIButton(type: .system)
    
    init(album: Album) {
        super.init(nibName: nil, bundle: nil)
        presenter = DetailPresenter(view: self, album: album)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter?.album.name
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        setupLayout()
        setupStyle()
        setupActions()
        
        presenter?.viewDidLoad(size: Int(view.bounds.width) - 32)
    }
    
    // MARK: - Setup
    private func setupLayout() {
        // scrollView & stack
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        // add arranged subviews
        [artworkImageView, titleLabel, artistLabel, infoLabel].forEach {
            contentStack.addArrangedSubview($0)
        }
        view.addSubview(spotifyButton)
        spotifyButton.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        NSLayoutConstraint.activate([
            // scrollView fills safe area
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            // contentStack inside scrollView
            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            // spotifyButton
            spotifyButton.widthAnchor.constraint(equalToConstant: 60),
            spotifyButton.heightAnchor.constraint(equalTo: spotifyButton.widthAnchor),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.topAnchor.constraint(equalTo: contentStack.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupStyle() {
        // artwork
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.clipsToBounds = true
        artworkImageView.layer.cornerRadius = 16
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        artworkImageView.heightAnchor.constraint(equalTo: artworkImageView.widthAnchor).isActive = true
        
        // labels
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        artistLabel.font = .systemFont(ofSize: 18)
        artistLabel.textColor = .darkGray
        artistLabel.numberOfLines = 0
        infoLabel.font = .systemFont(ofSize: 14)
        infoLabel.textColor = .gray
        infoLabel.numberOfLines = 0
        
        // spotifyButton
        spotifyButton.backgroundColor = UIColor(red: 29/255, green: 185/255, blue: 84/255, alpha: 1)
        if let spotifyImage = UIImage(named: "spotify")?.withRenderingMode(.alwaysTemplate) {
            spotifyButton.setImage(spotifyImage, for: .normal)
        }
        spotifyButton.tintColor = .white
        spotifyButton.layer.cornerRadius = 30
        spotifyButton.clipsToBounds = true
    }
    
    private func setupActions() {
        spotifyButton.addTarget(self, action: #selector(didTapSpotify), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func didTapSpotify() {
        presenter?.tapSpotify()
    }
}

extension DetailViewController: DetailView {
    func configure(with title: String, artist: String, info: String) {
        titleLabel.text = title
        artistLabel.text = artist
        infoLabel.text = info
    }
    
    func setImage(_ img: UIImage) {
        artworkImageView.image = img
    }
}
