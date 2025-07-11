//
//  AlbumDisplayModel.swift
//  MVVM
//
//  Created by 이현욱 on 7/11/25.
//

import UIKit

struct AlbumDisplayModel {
    let album: Album
    let image: UIImage
    
    init(album: Album, image: UIImage = UIImage(systemName: "photo")!) {
        self.album = album
        self.image = image
    }
}
