//
//  Recipe.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

struct Recipe: Codable, Equatable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: String
    let sourceUrl: String?
    let youtubeUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case cuisine, name, uuid
        case photoUrlLarge = "photo_url_large"
        case photoUrlSmall = "photo_url_small"
        case sourceUrl = "source_url"
        case youtubeUrl = "youtube_url"
    }
}

struct RecipeResponse: Codable {
    let recipes: [Recipe]
}
