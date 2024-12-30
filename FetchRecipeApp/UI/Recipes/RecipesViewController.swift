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
        title = "Recipes"
    }

    private func setupBindings() {
        viewModel.presentRecipeSourcePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                guard let url = url else { return }
                self?.presentRecipeSource(url: url)
            }
            .store(in: &subscriptions)
        
        viewModel.presentAlertPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] alert in
                self?.presentRecipeSourceAlert(alert: alert)
            }
            .store(in: &subscriptions)
    }
    
    private func presentRecipeSource(url: URL) {
        UIApplication.shared.open(url, options: [:])
    }
    
    private func presentRecipeSourceAlert(alert: RecipesAlert) {
        let alert = UIAlertController(
            title: alert.title,
            message: alert.message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
