//
//  AlbumsViewModel.swift
//  MVVM
//
//  Created by 이현욱 on 7/11/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol AlbumsViewModelType {
    var input: AlbumsViewModelInput { get }
    var output: AlbumsViewModelOutput { get }
}

protocol AlbumsViewModelInput {
    var viewDidLoad: AnyObserver<Void> { get }
}

protocol AlbumsViewModelOutput {
    var albums: Driver<[AlbumDisplayModel]> { get }
}

final class AlbumsViewModel: AlbumsViewModelType, AlbumsViewModelInput, AlbumsViewModelOutput {
    
    let disposeBag = DisposeBag()
    
    var input: AlbumsViewModelInput { self }
    var output: AlbumsViewModelOutput { self }
    
    var viewDidLoad: AnyObserver<Void> { viewDidLoadSubject.asObserver() }
    private let viewDidLoadSubject = PublishSubject<Void>()
    
    private let albumsRelay = BehaviorRelay<[AlbumDisplayModel]>(value: [])
    var albums: Driver<[AlbumDisplayModel]> {
        albumsRelay.asDriver()
    }
    
    init() {
        viewDidLoadSubject
            .flatMapLatest {
                APIClient.shared.fetchAlbums()
            }
            .flatMap { response -> Observable<[AlbumDisplayModel]> in
                let albums = response.albums.items

                let imageRequests = albums.map { album in
                    APIClient.shared.getImage(with: album.images.first?.url)
                        .map { image in
                            AlbumDisplayModel(album: album, image: image)
                        }
                        .asObservable()
                }

                return Observable.zip(imageRequests)
            }
            .subscribe(onNext: { [weak self] albumModels in
                self?.albumsRelay.accept(albumModels)
            }, onError: { error in
                print("Error fetching albums:", error)
            })
            .disposed(by: disposeBag)
    }
}
