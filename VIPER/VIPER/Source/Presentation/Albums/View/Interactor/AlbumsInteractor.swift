//
//  AlbumsInteractor.swift
//  VIPER
//
//  Created by 이현욱 on 7/14/25.
//

import Foundation

final class AlbumsInteractor: AlbumsUseCase {
    func fetchAlbums(_ completion: @escaping (Result<[Album], any Error>) -> ()) {
        Task {
            do {
                let albums = try await APIClient.shared.fetchAlbums()
                completion(.success(albums.albums.items))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func isFavorite(with id: String) -> Bool {
        FavoritesManager.shared.isFavorite(albumID: id)
    }
}
