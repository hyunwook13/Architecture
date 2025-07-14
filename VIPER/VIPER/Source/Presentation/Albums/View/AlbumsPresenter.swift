//
//  AlbumsPresenter.swift
//  VIPER
//
//  Created by 이현욱 on 7/3/25.
//

protocol AlbumsViewInput: AnyObject {
    func reloadData()
    func showError(_ message: String)
}

protocol AlbumsViewOutput: AnyObject {
    func viewDidLoad()
    func count() -> Int
    func configure(cell: AlbumCell, at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
}

import UIKit

final class AlbumsPresenter: AlbumsViewOutput {
    weak var view: AlbumsViewInput?
    private let interactor: AlbumsUseCase
    private let router: AlbumsRouter

    private var albums: [Album] = []

    init(view: AlbumsViewInput, interactor: AlbumsUseCase, router: AlbumsRouter) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchAlbums { [weak self] result in
            switch result {
            case .success(let albums):
                self?.albums = albums
                self?.view?.reloadData()
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }

    func count() -> Int {
        return albums.count
    }

    func configure(cell: AlbumCell, at indexPath: IndexPath) {
        let album = albums[indexPath.row]
        let isFavorite = interactor.isFavorite(with: album.id)
        let iteractor = AlbumsCellInteractor()
        let presenter = AlbumCellPresenter(album: album, isFavorite: isFavorite, iteractor: iteractor)
        
        cell.configure(presenter: presenter)
    }

    func didSelectRow(at indexPath: IndexPath) {
        let album = albums[indexPath.row]
        router.navigateToDetail(with: album)
    }
}
