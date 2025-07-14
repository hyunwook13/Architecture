//
//  AlbumsUseCase.swift
//  VIPER
//
//  Created by 이현욱 on 7/14/25.
//

import UIKit

protocol AlbumsUseCase {
    func fetchAlbums(_ completion: @escaping (Result<[Album], Error>) -> ())
    func isFavorite(with id: String) -> Bool
}
