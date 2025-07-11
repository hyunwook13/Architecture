//
//  FavoritesManager.swift
//  MVVM
//
//  Created by 이현욱 on 7/1/25.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {
        // 앱 시작 시 한 번만 로드
        if let saved = defaults.stringArray(forKey: favoritesKey) {
            _favoriteAlbumIDs = Set(saved)
        }
    }

    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoriteAlbumIDs"

    // 메모리에만 보관되는 변수
    // 외부에서 읽기만 허용
    private var _favoriteAlbumIDs: Set<String> = []
    var favoriteAlbumIDs: Set<String> { _favoriteAlbumIDs }

    /// 토글 방식으로 즐겨찾기 변경. 최종 상태를 반환합니다.
    @discardableResult
    func toggleFavorite(albumID: String) -> Bool {
        if _favoriteAlbumIDs.contains(albumID) {
            _favoriteAlbumIDs.remove(albumID)
        } else {
            _favoriteAlbumIDs.insert(albumID)
        }
        // 변경이 있을 때만 UserDefaults 에 저장
        defaults.set(Array(_favoriteAlbumIDs), forKey: favoritesKey)
        return _favoriteAlbumIDs.contains(albumID)
    }

    /// 특정 앨범이 즐겨찾기인지 여부
    func isFavorite(albumID: String) -> Bool {
        return _favoriteAlbumIDs.contains(albumID)
    }

    /// 모든 즐겨찾기 초기화
    func clearAll() {
        _favoriteAlbumIDs.removeAll()
        defaults.removeObject(forKey: favoritesKey)
    }
}
