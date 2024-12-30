//
//  MockAPIClient.swift
//  FetchRecipeAppTests
//
//  Created by Kevin Galarza on 12/30/24.
//

import Foundation
@testable import FetchRecipeApp

final class MockAPIClient: APIClientProtocol {
    var result: Result<RecipeResponse, Error>?

    func get<T>(_ endpoint: String) async throws -> T where T: Decodable {
        guard let result = result as? Result<T, Error> else {
            throw APIClientError.requestFailed
        }
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
