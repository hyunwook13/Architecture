//
//  RootRouter.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/24/25.
//

import RIBs

protocol RootInteractable: Interactable, AlbumsListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func pushViewController(_ viewController: ViewControllable, animated: Bool)
    
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {

    let albumBuilder: AlbumsBuildable
    private var album: ViewableRouting?
    
    init(interactor: RootInteractable, viewController: RootViewControllable, albumBuilder: AlbumsBuildable) {
        self.albumBuilder = albumBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        routeToAlbum()
    }
    
    private func routeToAlbum() {
        let album = albumBuilder.build(withListener: interactor)
        self.album = album
        attachChild(album)
        viewController.pushViewController(album.viewControllable, animated: true)
    }
    
    // 필요한 경우 detach 메서드도 추가
    private func detachAlbum() {
        guard let album = self.album else { return }
        detachChild(album)
        self.album = nil
    }
    
    deinit {
        print("RootRouter deinit")
    }
}
