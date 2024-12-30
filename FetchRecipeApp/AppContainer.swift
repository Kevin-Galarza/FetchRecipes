//
//  AppContainer.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import UIKit

class AppContainer {
    
    let sharedRecipesViewModel: RecipesViewModel
    let sharedAPIClient: APIClientProtocol
    let sharedImageLoader: ImageLoaderProtocol
    
    init() {
        let apiClient = makeAPIClient()
        let diskCache = makeDiskCache()
        let imageLoader = makeImageLoader(diskCache: diskCache)
        
        self.sharedRecipesViewModel = makeRecipesViewModel(apiClient: apiClient, imageLoader: imageLoader)
        self.sharedAPIClient = apiClient
        self.sharedImageLoader = imageLoader
        
        func makeRecipesViewModel(apiClient: APIClient, imageLoader: ImageLoader) -> RecipesViewModel {
            return RecipesViewModel(apiClient: apiClient, imageLoader: imageLoader)
        }
        
        func makeAPIClient() -> APIClient {
            guard let baseURL = URL(string: Configuration.recipesAPIHost) else {
                fatalError("Invalid base URL: \(Configuration.recipesAPIHost)")
            }
            return APIClient(baseURL: baseURL)
        }
        
        func makeDiskCache() -> DiskCache {
            do {
                return try DiskCache(storageType: Configuration.cacheStorageType)
            } catch {
                fatalError("DiskCache initialization failed")
            }
        }
        
        func makeImageLoader(diskCache: DiskCache?) -> ImageLoader {
            return ImageLoader(diskCache: diskCache)
        }
    }
    
    func makeRecipesViewController() -> UIViewController {
        UINavigationController(rootViewController: RecipesViewController(viewModel: sharedRecipesViewModel))
    }
}
