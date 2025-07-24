//
//  DetailInteractor.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/24/25.
//

import RIBs
import RxSwift

protocol DetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
    
    func setAlbum(with album: Album)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DetailListener: AnyObject {
    
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener {

    private let album: Album
    
    weak var router: DetailRouting?
    weak var listener: DetailListener?
    
    init(presenter: DetailPresentable, album: Album) {
        self.album = album
        super.init(presenter: presenter)
        presenter.listener = self
        presenter.setAlbum(with: album)
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func didTapPlayButton() {
        if let appURL = URL(string: album.uri), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:])
        } else if let webURL = URL(string: album.external_urls.spotify) {
            UIApplication.shared.open(webURL, options: [:])
        }
    }
}
