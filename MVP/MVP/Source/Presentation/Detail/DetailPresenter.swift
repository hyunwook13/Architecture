//
//  DetailPresenter.swift
//  MVP
//
//  Created by 이현욱 on 7/3/25.
//

import UIKit

final class DetailPresenter {
    var album: Album
    
    let view: DetailView
    
    init(view: DetailView, album: Album) {
      self.view = view
      self.album = album
    }
    
    func viewDidLoad(size: Int) {
      configureData()    // 텍스트ㆍ레이블 세팅
      loadImage(with: size)  // 비동기 이미지 로드
    }
    
    func tapSpotify() {
        if UIApplication.shared.canOpenURL(URL(string: album.uri)!) {
            UIApplication.shared.open(URL(string: album.uri)!, options: [:])
        } else if let webURL = URL(string: album.external_urls.spotify) {
            UIApplication.shared.open(webURL, options: [:])
        }
    }
    
    // MARK: - Configuration
    func configureData() {
        let artist = album.artists.map(\.name).joined(separator: ", ")
        let info = "\(album.release_date) • \(album.total_tracks) tracks"
        view.configure(with: album.name, artist: artist, info: info)
    }
    
    func loadImage(with size: Int) {
        Task {
            let size = CGSize(width: size, height: size)
            if let image = try? await APIClient.shared.getImage(with: album.images.first?.url, size: size) {
                DispatchQueue.main.async { [weak self] in
                    self?.view.setImage(image)
                }
            }
        }
    }
}
