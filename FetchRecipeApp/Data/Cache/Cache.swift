//
//  Cache.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

protocol Cache: Sendable {
    
    func fileURL(_ key: String) -> URL
    
    func syncCache(_ data: Data, key: String) throws
    func syncData(_ key: String) throws -> Data
    func syncDelete(_ key: String) throws
    func syncDeleteAll() throws

    func cache(_ data: Data, key: String) async throws
    func data(_ key: String) async throws -> Data
    func delete(_ key: String) async throws
    func deleteAll() async throws
}
