//
//  AlbumsCellUseCase.swift
//  VIPER
//
//  Created by 이현욱 on 7/14/25.
//

import UIKit

protocol AlbumsCellUseCase {
    func getImage(with urlStr: String?, _ completion: @escaping (Result<UIImage, Error>) -> ())
    @discardableResult func saveFavorite(with id: String) -> Bool
}

