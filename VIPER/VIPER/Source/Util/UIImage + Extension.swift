//
//  UIImage + Extension.swift
//  VIPER
//
//  Created by 이현욱 on 6/30/25.
//

import UIKit
import ImageIO

extension UIImage {
    /// Data를 지정한 최대 크기로 다운샘플링하여 UIImage 생성
    static func downsampledImage(from data: Data, to pointSize: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        // 1. 이미지 소스 생성
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false
        ]
        guard let source = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) else {
            return nil
        }

        // 2. 썸네일 생성 옵션
        let maxDimension = max(pointSize.width, pointSize.height) * scale
        let downsampleOptions: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: Int(maxDimension)
        ]

        // 3. 썸네일 생성
        guard let cgImage = CGImageSourceCreateThumbnailAtIndex(source, 0, downsampleOptions as CFDictionary) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}
