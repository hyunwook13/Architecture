//
//  AlbumsInteractor.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/22/25.
//

import RIBs
import RxSwift

protocol AlbumsRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func pushToDetail(with album: Album)
}

protocol AlbumsPresentable: Presentable {
    var listener: AlbumsPresentableListener? { get set }
    
    func loadedData(with albums: [Album])
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AlbumsListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AlbumsInteractor: PresentableInteractor<AlbumsPresentable>, AlbumsInteractable, AlbumsPresentableListener {

    weak var router: AlbumsRouting?
    weak var listener: AlbumsListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AlbumsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
        print("처리 끝")
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func loadAlbums() {
        print("loadAlbums")
        Task {
            do {
                let album = try await APIClient.shared.fetchAlbums()
                presenter.loadedData(with: album.albums.items)
            } catch {
                
            }
        }
    }
    
    func selectedAlbum(_ album: Album) {
        router?.pushToDetail(with: album)
    }
}
