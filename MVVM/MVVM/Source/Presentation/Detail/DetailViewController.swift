//
//  DetailViewController.swift
//  MVVM
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var vm: DetailViewModelType
    var playAlbumTap: (() -> Void)?

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
        btn.layer.cornerRadius = 30
        btn.clipsToBounds = true
        return btn
    }()

    // MARK: - Init
    init(_ vm: DetailViewModelType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        setupLayout()
        bind()
    }

    // MARK: - Layout
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
        NSLayoutConstraint.activate([
            spotifyButton.widthAnchor.constraint(equalToConstant: 60),
            spotifyButton.heightAnchor.constraint(equalToConstant: 60),
            spotifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spotifyButton.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20)
        ])
    }
    
    private func bind() {
        self.rx.viewWillAppear
            .map { _ in self.view.bounds.width - 32 }
            .bind(to: vm.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        spotifyButton.rx.tap
            .withUnretained(self)
            .map { _ in () }
            .bind(to: vm.input.tapSpotify)
            .disposed(by: disposeBag)
        
        vm.output.album
            .drive { [weak self] model in
                let album = model.album
                
                self?.titleLabel.text = album.name
                self?.artistLabel.text = album.artists.map(\.name).joined(separator: ", ")
                self?.infoLabel.text = "\(album.release_date) • \(album.total_tracks) tracks"
                self?.artworkImageView.image = model.image
            }.disposed(by: disposeBag)
    }
}
