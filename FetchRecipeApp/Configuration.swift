//
//  Configuration.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/30/24.
//

import Foundation

enum RecipesAPIPath: String {
    case normal = "/recipes.json"
    case malformed = "/recipes-malformed.json"
    case empty = "/recipes-empty.json"
}

// You can use this configuration to quickly switch between the different Recipes API path options and the storage location for the `DiskCache`.
struct Configuration {
    static let recipesAPIHost: String = "https://d3jbb8n5wk0qxi.cloudfront.net"
    static let recipesAPIPath: RecipesAPIPath = .normal
    static let cacheStorageType: StorageType = .temporary // .temporary (Caches directory) or .permanent (Documents directory)
}
