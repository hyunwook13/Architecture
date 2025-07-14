//
//  AlbumsRouter.swift
//  VIPER
//
//  Created by 이현욱 on 7/14/25.
//

import UIKit

protocol Router {
    func start()
}

protocol AlbumsRouter: Router {
    func navigateToDetail(with album: Album)
}

final class AlbumsRouterImpl: AlbumsRouter {
    
    private let nav: UINavigationController
    
    init(_ nav: UINavigationController) {
        self.nav = nav
    }
    
    func start() {
        let vc = AlbumsViewController()
        let iterator = AlbumsInteractor()
        let presenter = AlbumsPresenter(view: vc, interactor: iterator, router: self)
        vc.presenter = presenter
        
        nav.pushViewController(vc, animated: false)
    }
    
    func navigateToDetail(with album: Album) {
        let detailVC = DetailViewController()
        let presenter = DetailPresenter(view: detailVC, album: album)
        
        detailVC.presenter = presenter
        nav.pushViewController(detailVC, animated: true)
    }
}
