//
//  AlbumCellPresenter.swift
//  MVP
//
//  Created by 이현욱 on 7/3/25.
//

import UIKit

protocol AlbumCellView {
    func setImage(_ img: UIImage?)
    func configure(title: String, artist: [Artist], trackCount: Int, isFavorite: Bool)
}

final class AlbumCellPresenter {
    let view: AlbumCellView
    private var albumID: String!
    
    weak var delegate: AlbumCellDelegate?
    
    init(view: AlbumCellView) {
        self.view = view
    }
    
    func configure(view: AlbumCellView, albumID: String, title: String, artists: [Artist], trackCount: Int) {
        let isFavorite = FavoritesManager.shared.isFavorite(albumID: albumID)
        self.albumID = albumID
        view.configure(title: title, artist: artists, trackCount: trackCount, isFavorite: isFavorite)
    }
    
    func setImage(_ img: UIImage) {
        view.setImage(img)
    }
    
    func tapFavorite() {
        delegate?.albumCell(didToggleFavoriteFor: albumID)
    }
}
