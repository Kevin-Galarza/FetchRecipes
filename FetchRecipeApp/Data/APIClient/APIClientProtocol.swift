//
//  APIClientProtocol.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/30/24.
//

protocol APIClientProtocol {
    func get<T: Codable>(_ endpoint: String) async throws -> T
}
