//
//  AppContainer.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

class AppContainer {
    
    let sharedRecipesViewModel: RecipesViewModel
    
    init() {
        self.sharedRecipesViewModel = makeRecipesViewModel()
        
        func makeRecipesViewModel() -> RecipesViewModel {
            RecipesViewModel()
        }
    }
    
    func makeRecipesViewController() -> RecipesViewController {
        RecipesViewController(viewModel: sharedRecipesViewModel)
    }
}
