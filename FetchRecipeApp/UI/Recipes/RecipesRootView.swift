//
//  RecipesRootView.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation
import Combine

class RecipesRootView: NiblessView {
    
    let viewModel: RecipesViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(frame: CGRect = .zero, viewModel: RecipesViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
        applyStyle()
        setupBindings()
    }
    
    private func constructHierarchy() {
        
    }
    
    private func applyConstraints() {
        
    }
    
    private func applyStyle() {
        
    }
    
    private func setupBindings() {
        
    }
    
}
