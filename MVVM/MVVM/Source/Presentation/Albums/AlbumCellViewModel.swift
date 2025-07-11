//
//  AlbumCellViewModel.swift
//  MVVM
//
//  Created by 이현욱 on 7/11/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol AlbumCellModelType {
    var input: AlbumCellModelInput { get }
    var output: AlbumCellModelOutput { get }
}

protocol AlbumCellModelInput {
    var selectedLike: AnyObserver<String> { get }
}

protocol AlbumCellModelOutput {
//    var albums: Driver<[AlbumDisplayModel]> { get }
}

final class AlbumCellViewModel: AlbumCellModelType, AlbumCellModelInput, AlbumCellModelOutput {
    
    private let disposeBag = DisposeBag()
    weak var delegate: AlbumCellDelegate?
    
    var input: AlbumCellModelInput { self }
    var output: AlbumCellModelOutput { self }
    
    var selectedLikeSubject = PublishSubject<String>()
    var selectedLike: AnyObserver<String> {
        selectedLikeSubject.asObserver()
    }
    
    init() {
        selectedLikeSubject
            .bind {
                self.delegate?.albumCell(didToggleFavoriteFor: $0)
            }.disposed(by: disposeBag)
    }
}
