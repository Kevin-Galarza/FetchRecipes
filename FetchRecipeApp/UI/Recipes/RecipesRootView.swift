//
//  RecipesRootView.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit
import Combine

class RecipesRootView: NiblessView {
    let viewModel: RecipesViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipesFilterChipCell.self, forCellWithReuseIdentifier: RecipesFilterChipCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var recipesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecipesCollectionViewCell.self, forCellWithReuseIdentifier: RecipesCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "No recipes available."
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    init(frame: CGRect = .zero, viewModel: RecipesViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        constructHierarchy()
        applyConstraints()
        setupBindings()
        applyStyle()
        viewModel.refresh()
    }
    
    @objc private func handleRefresh() {
        viewModel.refresh()
    }

    private func constructHierarchy() {
        addSubview(filterCollectionView)
        addSubview(recipesCollectionView)
        addSubview(placeholderLabel)
    }
    
    private func applyConstraints() {
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recipesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterCollectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            filterCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            recipesCollectionView.topAnchor.constraint(equalTo: filterCollectionView.bottomAnchor),
            recipesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            recipesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            recipesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        viewModel.$filteredRecipes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.recipesCollectionView.reloadData()
                self?.filterCollectionView.reloadData()
                self?.refreshControl.endRefreshing()
                
                recipes.isEmpty ? (self?.placeholderLabel.isHidden = false) : (self?.placeholderLabel.isHidden = true)
                recipes.isEmpty ? (self?.filterCollectionView.isHidden = true) : (self?.filterCollectionView.isHidden = false)
            }
            .store(in: &subscriptions)
    }
    
    private func applyStyle() {
        backgroundColor = .white
        filterCollectionView.backgroundColor = .white
        recipesCollectionView.backgroundColor = .white
    }
}

// MARK: - UICollectionViewDataSource, Delegate, and DelegateFlowLayout

extension RecipesRootView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == filterCollectionView {
            return viewModel.cuisines.count
        } else {
            return viewModel.filteredRecipes.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == filterCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesFilterChipCell.reuseIdentifier, for: indexPath) as! RecipesFilterChipCell
            let cuisine = viewModel.cuisines[indexPath.item]
            
            cell.configure(with: cuisine, isSelected: cuisine == viewModel.selectedCuisine)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesCollectionViewCell.reuseIdentifier, for: indexPath) as! RecipesCollectionViewCell
            let recipe = viewModel.filteredRecipes[indexPath.item]
            
            Task {
                if let image = await viewModel.loadImage(for: recipe) {
                    cell.configure(with: recipe.name, cuisine: recipe.cuisine, image: image)
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == filterCollectionView {
            let selectedCuisine = viewModel.cuisines[indexPath.item ]
            
            viewModel.selectedCuisine = selectedCuisine
            viewModel.filterRecipes(by: selectedCuisine)
        } else {
            let recipe = viewModel.filteredRecipes[indexPath.item]
            
            viewModel.presentRecipeSource(for: recipe)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == filterCollectionView {
            return CGSize(width: 100, height: 36)
        } else {
            let padding: CGFloat = 16 * 2
            let interItemSpacing: CGFloat = 16
            let availableWidth = collectionView.bounds.width - padding - interItemSpacing
            let widthPerItem = floor(availableWidth / 2)
            let heightPerItem: CGFloat = 250
            
            return CGSize(width: widthPerItem, height: heightPerItem)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
