//
//  AlbumsPresenter.swift
//  MVP
//
//  Created by 이현욱 on 7/3/25.
//

import UIKit

final class AlbumsPresenter {
    // 내부 상태
    private var albums: [Album] = []
    
    // 바인딩 클로저
    var onAlbumsChanged: (([Album]) -> Void)?
    var onError: ((String) -> Void)?
    var onSelectAlbum: ((Album) -> Void)?
    
    func viewDidLoad() {
        fetchAlbums()
        print("out")
    }
    
    func count() -> Int { albums.count }
    func album(at idx: IndexPath) -> Album { albums[idx.row] }
    
    func didSelectRow(at idx: IndexPath) {
        let a = album(at: idx)
        onSelectAlbum?(a)
    }
    
    private func fetchAlbums() {
        Task {
            do {
                let resp = try await APIClient.shared.fetchAlbums()
                albums = resp.albums.items
                onAlbumsChanged?(albums)
            } catch {
                onError?("앨범을 불러올 수 없습니다.")
            }
        }
    }
    
    func configure(cell: AlbumCell, at indexPath: IndexPath) {
        let album = albums[indexPath.row]
        let isFav = FavoritesManager.shared.isFavorite(albumID: album.id)
        
        // 텍스트·상태 세팅
        cell.configure(title: album.name, artist: album.artists, trackCount: album.total_tracks, isFavorite: isFav)
        
        // 이미지 로드
        Task {
            let image = try? await APIClient.shared.getImage(with: album.images.first?.url)
            DispatchQueue.main.async {
                cell.setImage(image)
            }
        }
    }
}

//final class AlbumsPresenter {
//    private var albums: [Album] = []
//
//    private var view: AlbumsView!
//
//    init(view: AlbumsView) {
//        self.view = view
//    }
//
//    func viewDidLoad() {
//        fetchAlbums()
//    }
//
//    func count() -> Int {
//        return albums.count
//    }
//
//    func album(at idx: IndexPath) -> Album {
//        return albums[idx.row]
//    }
//
//    func selectedAt(_ idx: IndexPath) {
//        let album = album(at: idx)
//        view?.showAlbumDetail(with: album)
//    }
//
//    func getImage(with url: String?) async -> UIImage? {
//        guard let urlStr = url else { return nil }
//
//        do {
//            let img = try await APIClient.shared.getImage(with: urlStr)
//            return img
//        } catch {
//            return nil
//        }
//    }
//
//    func configure(_ cell: AlbumCell, at indexPath: IndexPath) {
//        let album = album(at: indexPath)
//
//        cell.presenter = AlbumCellPresenter(view: cell)
//
//        cell.presenter!.configure(view: cell, albumID: album.id, title: album.name, artist: album.artists.first?.name, trackCount: album.total_tracks)
//
//        cell.presenter!.delegate = self
//
//        Task {
//            if let url = album.images.first?.url,
//               let img = await getImage(with: url) {
//                DispatchQueue.main.async {
//                    cell.presenter!.setImage(img)
//                }
//            }
//        }
//    }
//
//    private func fetchAlbums() {
//        Task {
//            do {
//                let response = try await APIClient.shared.fetchAlbums()
//                albums = response.albums.items
//                view?.showAlbums()
//            } catch {
//                view?.showError("앨범을 불러오지 못했습니다.")
//            }
//        }
//    }
//}
//
//extension AlbumsPresenter: AlbumCellDelegate {
//    func albumCell(didToggleFavoriteFor albumID: String) {
//        FavoritesManager.shared.toggleFavorite(albumID: albumID)
//    }
//}
