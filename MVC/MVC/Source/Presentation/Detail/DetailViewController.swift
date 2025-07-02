//
//  DetailViewController.swift
//  MVC
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit

final class DetailViewController: UIViewController {
    private let detailView = DetailView()
    private var album: Album!
    
    // 편의 초기화
    init(album: Album) {
        super.init(nibName: nil, bundle: nil)
        self.album = album
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setAction()
    }
    
    private func setup() {
        title = album.name
        navigationItem.largeTitleDisplayMode = .never
        
        let artistNames = album.artists.map(\.name).joined(separator: ", ")
        let infoText = "\(album.release_date) • \(album.total_tracks) tracks"
        detailView.configure(title: album.name, artist: artistNames, info: infoText)
        
        // 이미지 비동기 로드
        Task {
            let width = view.bounds.width - 32
            let size = CGSize(width: width, height: width)
            print(size)
            let image = try await APIClient.shared.getImage(with: album.images.first?.url, size: size)
            detailView.setImage(image)
        }
    }
    
    private func setAction() {
        detailView.playAlbumTap = {
            if UIApplication.shared.canOpenURL(URL(string: self.album.uri)!) {
                // 앱이 설치되어 있으면 딥링크 실행
                UIApplication.shared.open(URL(string: self.album.uri)!, options: [:], completionHandler: nil)
            } else if let webURL = URL(string: self.album.external_urls.spotify) {
                // 없으면 웹페이지로 대체
                UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
            }
        }
    }
}

