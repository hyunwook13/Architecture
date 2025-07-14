//
//  ImageCache.swift
//  VIPER
//
//  Created by 이현욱 on 7/2/25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024
    }
    
    private func cacheKey(for url: String, size: CGSize) -> NSString {
        return "\(url)-\(Int(size.width))x\(Int(size.height))" as NSString
    }
    
    func image(for url: String, size: CGSize) -> UIImage? {
        let key = cacheKey(for: url, size: size)
        return cache.object(forKey: key)
    }
    
    func insert(_ image: UIImage, for url: String, size: CGSize) {
        let key = cacheKey(for: url, size: size)
        let cost = Int(image.size.width * image.size.height * image.scale * image.scale)
        cache.setObject(image, forKey: key, cost: cost)
    }
}
