//
//  Album.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import Foundation

// 최상위 응답
struct BrowseNewReleasesResponse: Codable {
    let albums: Albums
}

// albums 오브젝트
struct Albums: Codable {
    let href: String
    let items: [Album]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}

// 각 앨범 정보
struct Album: Codable {
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: ExternalURLs
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let release_date: String
    let release_date_precision: String
    let total_tracks: Int
    let type: String
    let uri: String
}

// 아티스트 정보
struct Artist: Codable {
    let external_urls: ExternalURLs
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}

// 외부 URL
struct ExternalURLs: Codable {
    let spotify: String
}

// 이미지 정보
struct Image: Codable {
    let height: Int
    let url: String
    let width: Int
}
