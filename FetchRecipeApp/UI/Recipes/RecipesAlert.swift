//
//  RecipesAlert.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/30/24.
//

enum RecipesAlert {
    case sourceUnavailable, recipesUnavailable
    
    var title: String {
        switch self {
        case .sourceUnavailable: "Recipe URL Unavailable"
        case .recipesUnavailable: "Recipes Unavailable"
        }
    }
    
    var message: String {
        switch self {
        case .sourceUnavailable: "We're having some trouble opening the URL for this recipe at the moment."
        case .recipesUnavailable: "We're having some issues fetching recipes. Please try again later."
        }
    }
}
