//
//  AlbumsViewController.swift
//  MVVM
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

import RxSwift
import RxCocoa

class AlbumsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let vm: AlbumsViewModelType
    
    private let tableView = UITableView()
    
    init(_ vm: AlbumsViewModelType) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupTableView()
        bind()
    }
    
    private func setupNavigationBar() {
        title = "Albums"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.rowHeight = 100
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reuseIdentifier)
    }
    private func bind() {
        self.rx.viewWillAppear
            .take(1)
            .map { _ in () }
            .bind(to: vm.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AlbumDisplayModel.self)
            .bind { model in
                let vm = DetailViewModel(album: model.album)
                let detailVC = DetailViewController(vm)
                self.navigationController?.pushViewController(detailVC, animated: true)
            }.disposed(by: disposeBag)
        
        vm.output.albums
            .drive(tableView.rx.items(cellIdentifier: AlbumCell.reuseIdentifier, cellType: AlbumCell.self)) { _, displayModel, cell in
                let vm = AlbumCellViewModel()
                let isFavorite = FavoritesManager.shared.isFavorite(albumID: displayModel.album.id)
                vm.delegate = self
                cell.configure(with: displayModel.album, isFavorite: isFavorite)
                cell.setImage(displayModel.image)
                cell.setting(with: vm)
            }.disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension AlbumsViewController: UITableViewDelegate { }

// MARK: - AlbumCellDelegate
extension AlbumsViewController: AlbumCellDelegate {
    func albumCell(didToggleFavoriteFor albumID: String) {
        FavoritesManager.shared.toggleFavorite(albumID: albumID)
    }
}
