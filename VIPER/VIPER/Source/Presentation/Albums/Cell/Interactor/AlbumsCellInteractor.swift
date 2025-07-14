//
//  AlbumsCellInteractor.swift
//  VIPER
//
//  Created by 이현욱 on 7/14/25.
//

import UIKit

final class AlbumsCellInteractor: AlbumsCellUseCase {
    @discardableResult func saveFavorite(with id: String) -> Bool {
        FavoritesManager.shared.toggleFavorite(albumID: id)
    }
    
    func getImage(with urlStr: String?, _ completion: @escaping (Result<UIImage, Error>) -> ()) {
        Task {
            do {
                let image = try await APIClient.shared.getImage(with: urlStr)
                completion(.success(image))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
