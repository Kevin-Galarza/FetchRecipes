//
//  DiskCache.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

typealias VoidUnsafeContinuation = UnsafeContinuation<Void, Error>

final class DiskCache: Cache {
    let storageType: StorageType

    init(storageType: StorageType) throws {
        self.storageType = storageType
        try createDirectory(directoryURL)
    }

}

// MARK: - Asynchronous Methods

extension DiskCache {
    func cache(_ data: Data, key: String) async throws {
        try await withUnsafeThrowingContinuation { (continuation: VoidUnsafeContinuation) -> Void in
            do {
                try syncCache(data, key: key)
                continuation.resume()
            } catch {
                Logger.shared.error("\(error)")
                continuation.resume(throwing: error)
            }
        }
    }
    
    func data(_ key: String) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            do {
                let data = try syncData(key)
                continuation.resume(returning: data)
            } catch {
                Logger.shared.error("\(error)")
                continuation.resume(throwing: error)
            }
        }
    }

    func delete(_ key: String) async throws {
        try await withUnsafeThrowingContinuation { (continuation: VoidUnsafeContinuation) -> Void in
            do {
                try syncDelete(key)
                continuation.resume()
            } catch {
                Logger.shared.error("\(error)")
                continuation.resume(throwing: error)
            }
        }
    }

    func deleteAll() async throws {
        try await withUnsafeThrowingContinuation { (continuation: VoidUnsafeContinuation) -> Void in
            do {
                try syncDeleteAll()
                continuation.resume()
            } catch {
                Logger.shared.error("\(error)")
                continuation.resume(throwing: error)
            }
        }
    }

    func fileURL(_ key: String) -> URL {
        return directoryURL.appendingPathComponent(key)
    }
}

// MARK: - Synchronous Methods

extension DiskCache {
    func syncCache(_ data: Data, key: String) throws {
        Logger.shared.info("writing cache with key: \(key)")
        try data.write(to: fileURL(key))
    }

    func syncData(_ key: String) throws -> Data {
        Logger.shared.info("reading cache with key: \(key)")
        return try Data(contentsOf: fileURL(key))
    }

    func syncDelete(_ key: String) throws {
        Logger.shared.info("deleting cache with key: \(key)")
        try FileManager.default.removeItem(at: fileURL(key))
    }

    func syncDeleteAll() throws {
        Logger.shared.info("clearing cache")
        try FileManager.default.removeItem(at: directoryURL)
        try createDirectory(directoryURL)
    }
}

// MARK: - Helpers

extension DiskCache {
    var searchPathDirectory: FileManager.SearchPathDirectory? {
        switch storageType {
            case .temporary: return .cachesDirectory
            case .permanent: return .documentDirectory
        }
    }

    var directoryURL: URL {
        var basePath: URL {
            guard let searchPathDirectory = searchPathDirectory,
                  let searchPath = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask)
                    .first else {
                        fatalError("\(#function) Fatal: Cannot get user directory.")
                    }

            return searchPath
        }

        return basePath.appendingPathComponent("com.galarza.cache")
    }

    func createDirectory(_ url: URL) throws {
        try FileManager.default
            .createDirectory(
                at: url,
                withIntermediateDirectories: true,
                attributes: nil)
    }
}
