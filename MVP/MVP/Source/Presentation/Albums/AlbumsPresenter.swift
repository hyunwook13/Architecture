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
    }
    
    func count() -> Int { albums.count }
    func album(at idx: IndexPath) -> Album { albums[idx.row] }
    
    func didSelectRow(at idx: IndexPath) {
        let album = album(at: idx)
        onSelectAlbum?(album)
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
