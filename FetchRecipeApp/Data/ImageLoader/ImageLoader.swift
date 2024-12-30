//
//  ImageLoader.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit

final class ImageLoader: ImageLoaderProtocol {
    private let diskCache: Cache?
    private let memoryCache = NSCache<NSString, UIImage>()
    private let urlSession: URLSession

    init(diskCache: Cache?, urlSession: URLSession = .shared) {
        self.diskCache = diskCache
        self.urlSession = urlSession
    }

    /// Loads a single image for a given URL.
    func loadImage(id: String, url: String) async -> UIImage? {
        let cacheKey = id as NSString

        // Try memory cache first
        if let cachedImage = memoryCache.object(forKey: cacheKey) {
            Logger.shared.info("Loading image from memory")
            return cachedImage
        }

        // Try disk cache second
        if let imageFromDisk = try? await loadFromDisk(key: id) {
            Logger.shared.info("Loading image from disk")
            memoryCache.setObject(imageFromDisk, forKey: cacheKey)
            return imageFromDisk
        }

        // Fetch from network if not in memory or on disk
        guard let url = URL(string: url) else { return nil }

        do {
            Logger.shared.info("Loading image from web")
            
            let (data, _) = try await urlSession.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            // Cache the downloaded image
            memoryCache.setObject(image, forKey: cacheKey)
            try await diskCache?.cache(data, key: id)
            
            return image
        } catch {
            Logger.shared.error(error.localizedDescription)
            return nil
        }
    }

    private func loadFromDisk(key: String) async throws -> UIImage? {
        guard let data = try await diskCache?.data(key) else { return nil }
        return UIImage(data: data)
    }
}
