//
//  DetailPresenter.swift
//  VIPER
//
//  Created by 이현욱 on 7/3/25.
//

import UIKit

final class DetailPresenter: DetailViewOutput {
    
    var album: Album
    let view: DetailViewInput
    
    init(view: DetailViewInput, album: Album) {
        self.view = view
        self.album = album
    }
    
    func viewDidLoad(with size: CGFloat) {
        configureData()
        loadImage(with: size)
    }
    
    func loadImage(with size: CGFloat) {
        Task {
            let size = CGSize(width: size, height: size)
            
            if let image = try? await APIClient.shared.getImage(with: album.images.first?.url, size: size) {
                view.setImage(image)
            }
        }
    }
    
    func tapSpotify() {
        if let appURL = URL(string: album.uri), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else if let webURL = URL(string: album.external_urls.spotify) {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Configuration
    private func configureData() {
        let artist = album.artists.map(\.name).joined(separator: ", ")
        let info = "\(album.release_date) • \(album.total_tracks) tracks"
        view.configure(title: album.name, artist: artist, info: info)
    }
}
