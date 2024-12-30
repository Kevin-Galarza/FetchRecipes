//
//  DiskCacheTests.swift
//  FetchRecipeAppTests
//
//  Created by Kevin Galarza on 12/29/24.
//

import XCTest
@testable import FetchRecipeApp

final class DiskCacheTests: XCTestCase {

    func testCacheAndRetrieveData() async throws {
        let cache = try DiskCache(storageType: .temporary)
        let testKey = "testFile"
        let testData = "Hello, DiskCache!".data(using: .utf8)!

        try await cache.cache(testData, key: testKey)

        let retrievedData = try await cache.data(testKey)
        XCTAssertEqual(retrievedData, testData, "Retrieved data should match the original data")
    }
    
    func testDeleteSingleKey() async throws {
        let cache = try DiskCache(storageType: .temporary)
        let testKey = "testFile"
        let testData = "Delete me!".data(using: .utf8)!

        try await cache.cache(testData, key: testKey)
        try await cache.delete(testKey)
        
        var didFailWithError: Error?
        do {
            // This call is expected to fail
            _ = try await cache.data(testKey)
        } catch {
            didFailWithError = error
        }

        XCTAssertNotNil(didFailWithError)
    }

    func testDeleteAll() async throws {
        let cache = try DiskCache(storageType: .temporary)
        let testData = "Temporary data".data(using: .utf8)!
        let testKeys = ["file1", "file2", "file3"]
        
        for key in testKeys {
            try await cache.cache(testData, key: key)
        }

        try await cache.deleteAll()

        let directoryContents = try FileManager.default.contentsOfDirectory(at: cache.directoryURL, includingPropertiesForKeys: nil)
        XCTAssertTrue(directoryContents.isEmpty, "Expected all files to be deleted")
    }
}
