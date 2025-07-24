//
//  AlbumsBuilder.swift
//  RIBs-Study
//
//  Created by 이현욱 on 7/22/25.
//

import RIBs

protocol AlbumsDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AlbumsComponent: Component<AlbumsDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AlbumsBuildable: Buildable {
    func build(withListener listener: AlbumsListener) -> AlbumsRouting
}

final class AlbumsBuilder: Builder<AlbumsDependency>, AlbumsBuildable {
    override init(dependency: AlbumsDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AlbumsListener) -> AlbumsRouting {
        let component = AlbumsComponent(dependency: dependency)
        let vc = AlbumsViewController()
        let interactor = AlbumsInteractor(presenter: vc)
        interactor.listener = listener
        
        let builder = DetailBuilder(dependency: component)
        
        let router = AlbumsRouter(
            interactor: interactor,
            viewController: vc,
            detailBuildable: builder
        )
        
        return router
    }
}

extension AlbumsComponent: DetailDependency {}
