//
//  ViewController.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit
import Combine

class RecipesViewController: NiblessViewController {
    
    let viewModel: RecipesViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    init(viewModel: RecipesViewModel) {
        self.viewModel = viewModel
        super.init()
        setupBindings()
    }
    
    override func loadView() {
        view = RecipesRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func setupBindings() {
        
    }

}

