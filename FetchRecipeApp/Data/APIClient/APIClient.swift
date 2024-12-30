//
//  APIClient.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

enum APIClientError: Error {
    case invalidURL
    case requestFailed
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed:
            return "The request failed due to network issues."
        case .decodingFailed:
            return "Failed to decode the response."
        }
    }
}

final class APIClient: APIClientProtocol {
    private let baseURL: URL
    private let session: URLSession

    init(baseURL: URL, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
    }

    func get<T: Codable>(_ endpoint: String) async throws -> T {
            guard var urlComponents = URLComponents(url: baseURL.appendingPathComponent(endpoint), resolvingAgainstBaseURL: true) else {
            throw APIClientError.invalidURL
        }

        guard let url = urlComponents.url else {
            throw APIClientError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        // Check for valid HTTP response
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIClientError.requestFailed
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIClientError.decodingFailed
        }
    }
}
