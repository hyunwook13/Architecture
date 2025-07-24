//
//  AlbumsRouter.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/22/25.
//

import RIBs

protocol AlbumsInteractable: Interactable, DetailListener {
    var router: AlbumsRouting? { get set }
    var listener: AlbumsListener? { get set }
}

protocol AlbumsViewControllable: ViewControllable {
    func pushToDetail(viewController: ViewControllable)
}

final class AlbumsRouter: ViewableRouter<AlbumsInteractable, AlbumsViewControllable>, AlbumsRouting {

    private let detailBuildable: DetailBuildable

    init(interactor: AlbumsInteractor,
         viewController: AlbumsViewControllable,
         detailBuildable: DetailBuildable) {
//        self.viewController = viewController
        self.detailBuildable = detailBuildable
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func pushToDetail(with album: Album) {
        let albumDetail = detailBuildable.build(withListener: interactor, with: album)
        attachChild(albumDetail)
        viewController.pushToDetail(viewController: albumDetail.viewControllable)
    }
}

