//
//  FavoritesManager.swift
//  MVC
//
//  Created by 이현욱 on 7/1/25.
//

import Foundation

final class FavoritesManager {
    static let shared = FavoritesManager()
    private init() {}
    
    private let defaults = UserDefaults.standard
    private let favoritesKey = "favoriteAlbumIDs"
    
    /// 현재 저장된 즐겨찾기 ID 세트
    private(set) var favoriteAlbumIDs: Set<String> {
      get {
        let array = defaults.stringArray(forKey: favoritesKey) ?? []
        return Set(array)
      }
      set {
        defaults.set(Array(newValue), forKey: favoritesKey)
      }
    }
    
    /// 토글 방식으로 즐겨찾기 변경. 최종 상태를 반환합니다.
    @discardableResult
    func toggleFavorite(albumID: String) -> Bool {
        var ids = favoriteAlbumIDs
        if ids.contains(albumID) {
            ids.remove(albumID)
        } else {
            ids.insert(albumID)
        }
        favoriteAlbumIDs = ids
        return ids.contains(albumID)
    }
    
    /// 특정 앨범이 즐겨찾기인지 여부
    func isFavorite(albumID: String) -> Bool {
        return favoriteAlbumIDs.contains(albumID)
    }
    
    /// 모든 즐겨찾기 초기화
    func clearAll() {
        favoriteAlbumIDs = []
    }
}
