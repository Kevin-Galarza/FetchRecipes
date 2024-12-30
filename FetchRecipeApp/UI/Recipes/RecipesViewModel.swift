//
//  RecipesViewModel.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit
import Combine

class RecipesViewModel {
    let apiClient: APIClientProtocol
    let imageLoader: ImageLoaderProtocol
    
    var recipes: [Recipe] = []
    var cuisines: [String] = ["All"]
    var selectedCuisine: String = "All"
    
    @Published var filteredRecipes: [Recipe] = []
    
    let presentRecipeSourcePublisher = PassthroughSubject<URL?, Never>()
    let presentAlertPublisher = PassthroughSubject<RecipesAlert, Never>()

    init(apiClient: APIClientProtocol, imageLoader: ImageLoaderProtocol) {
        self.apiClient = apiClient
        self.imageLoader = imageLoader
    }
    
    func refresh() {
        fetchRecipes()
    }
    
    func filterRecipes(by cuisine: String) {
        selectedCuisine = cuisine
        if cuisine == "All" {
            filteredRecipes = recipes
        } else {
            filteredRecipes = recipes.filter { $0.cuisine == cuisine }
        }
    }
    
    func loadImage(for recipe: Recipe) async -> UIImage? {
        await imageLoader.loadImage(id: recipe.uuid, url: recipe.photoUrlSmall ?? "")
    }
    
    func presentRecipeSource(for recipe: Recipe) {
        if let sourceURL = recipe.sourceUrl {
            presentRecipeSourcePublisher.send(URL(string: sourceURL))
        } else if let youtubeURL = recipe.youtubeUrl {
            presentRecipeSourcePublisher.send(URL(string: youtubeURL))
        } else {
            presentAlertPublisher.send(RecipesAlert.sourceUnavailable)
        }
    }
    
    private func fetchRecipes() {
        Task {
            do {
                Logger.shared.info("Fetching recipes from API")
                let response: RecipeResponse = try await apiClient.get(Configuration.recipesAPIPath.rawValue)
                DispatchQueue.main.async {
                    self.recipes = response.recipes
                    self.filterRecipes(by: self.selectedCuisine)
                    self.updateCuisines()
                }
            } catch {
                Logger.shared.error("Failed to fetch recipes: \(error)")
                DispatchQueue.main.async {
                    self.filteredRecipes = []
                }
                self.presentAlertPublisher.send(RecipesAlert.recipesUnavailable)
            }
        }
    }
    
    private func updateCuisines() {
        // Add unique cuisines sorted alphabetically after "All"
        let uniqueCuisines = Array(Set(recipes.map { $0.cuisine })).sorted()
        self.cuisines = ["All"] + uniqueCuisines
    }
}
