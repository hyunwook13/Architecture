//
//  AlbumCellPresenter.swift
//  VIPER
//
//  Created by 이현욱 on 7/3/25.
//

import UIKit

protocol AlbumsCellViewInput: AnyObject {
    func reloadCell(_ res: Bool)
    func configure(_ album: Album)
    func setImage(_ img: UIImage)
    func setFavorite(_ isFavorite: Bool)
}

protocol AlbumsCellViewOutput: AnyObject {
    func viewDidLoad(_ view: AlbumsCellViewInput)
    func tapFavorite()
}

protocol AlbumCellView {
    func setImage(_ img: UIImage?)
    func configure(with album: Album, isFavorite: Bool)
}

final class AlbumCellPresenter: AlbumsCellViewOutput {
    
    var view: AlbumsCellViewInput!
    private var isFavorite: Bool
    private var album: Album!
    private var iteractor: AlbumsCellUseCase!
    
    init(album: Album, isFavorite: Bool, iteractor: AlbumsCellUseCase) {
        self.album = album
        self.isFavorite = isFavorite
        self.iteractor = iteractor
    }
    
    func viewDidLoad(_ view: AlbumsCellViewInput) {
        self.view = view
        view.setFavorite(isFavorite)
        view.configure(album)
        getImage()
    }
    
    func tapFavorite() {
        let res = iteractor.saveFavorite(with: album.id)
        view.reloadCell(res)
    }
    
    private func getImage() {
        iteractor.getImage(with: album.images.first?.url) { [weak self] res in
            switch res {
            case .success(let image):
                self?.view.setImage(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
