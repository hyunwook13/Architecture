//
//  DetailViewModel.swift
//  MVVM
//
//  Created by 이현욱 on 7/12/25.
//

import Foundation

//
//  AlbumsViewModel.swift
//  MVVM
//
//  Created by 이현욱 on 7/11/25.
//

import UIKit

import RxSwift
import RxCocoa

protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}

protocol DetailViewModelInput {
    var tapSpotify: AnyObserver<Void> { get }
    var viewWillAppear: AnyObserver<CGFloat> { get }
}

protocol DetailViewModelOutput {
    var album: Driver<AlbumDisplayModel> { get }
}

final class DetailViewModel: DetailViewModelType, DetailViewModelInput, DetailViewModelOutput {
    
    let disposeBag = DisposeBag()
    
    var input: DetailViewModelInput { self }
    var output: DetailViewModelOutput { self }
    
    var viewWillAppear: AnyObserver<CGFloat> { viewWillAppearSubject.asObserver() }
    private let viewWillAppearSubject = PublishSubject<CGFloat>()
    
    var tapSpotify: AnyObserver<Void> { tapSpotifySubject.asObserver() }
    private let tapSpotifySubject = PublishSubject<Void>()
    
    private let albumRelay = PublishSubject<AlbumDisplayModel>()
    var album: Driver<AlbumDisplayModel> {
        albumRelay.asDriver(onErrorJustReturn: AlbumDisplayModel(album: .empty))
    }
    
    init(album: Album) {
        tapSpotifySubject
            .bind {
            if UIApplication.shared.canOpenURL(URL(string: album.uri)!) {
                UIApplication.shared.open(URL(string: album.uri)!, options: [:])
            } else if let webURL = URL(string: album.external_urls.spotify) {
                UIApplication.shared.open(webURL, options: [:])
            }
        }.disposed(by: disposeBag)
        
        viewWillAppearSubject
            .filter { _ in album.images.last != nil }
            .flatMap {
                APIClient.shared.getImage(with: album.images.last!.url, size: CGSize(width: $0, height: $0))
            }.bind { [weak self] image in
                let album = AlbumDisplayModel(album: album, image: image)
                self?.albumRelay.onNext(album)
            }.disposed(by: disposeBag)
    }
}
