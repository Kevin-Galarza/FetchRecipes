//
//  RecipesViewModelTests.swift
//  FetchRecipeAppTests
//
//  Created by Kevin Galarza on 12/30/24.
//

import XCTest
import Combine
@testable import FetchRecipeApp

final class RecipesViewModelTests: XCTestCase {
    var viewModel: RecipesViewModel!
    var apiClientMock: MockAPIClient!
    var imageLoaderMock: MockImageLoader!

    override func setUp() {
        super.setUp()
        apiClientMock = MockAPIClient()
        imageLoaderMock = MockImageLoader()
        viewModel = RecipesViewModel(apiClient: apiClientMock, imageLoader: imageLoaderMock)
    }

    override func tearDown() {
        viewModel = nil
        apiClientMock = nil
        imageLoaderMock = nil
        super.tearDown()
    }

    func testFilterRecipesByCuisine() {
        let recipe1 = Recipe(cuisine: "Italian", name: "Pasta", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "1", sourceUrl: nil, youtubeUrl: nil)
        let recipe2 = Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "2", sourceUrl: nil, youtubeUrl: nil)

        viewModel.recipes = [recipe1, recipe2]
        viewModel.filterRecipes(by: "Italian")

        XCTAssertEqual(viewModel.filteredRecipes, [recipe1])
        XCTAssertEqual(viewModel.selectedCuisine, "Italian")
    }

    func testFetchRecipesSuccess() async {
        let recipe1 = Recipe(cuisine: "Italian", name: "Pasta", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "1", sourceUrl: nil, youtubeUrl: nil)
        let recipe2 = Recipe(cuisine: "Japanese", name: "Sushi", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "2", sourceUrl: nil, youtubeUrl: nil)
        let response = RecipeResponse(recipes: [recipe1, recipe2])
        apiClientMock.result = .success(response)

        let expectation = expectation(description: "Fetch recipes completes")
        
        // Observe changes to filteredRecipes to know when the fetch is complete
        let subscription = viewModel.$filteredRecipes
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }

        viewModel.refresh()

        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertEqual(viewModel.recipes, [recipe1, recipe2])
        XCTAssertEqual(viewModel.filteredRecipes, [recipe1, recipe2])
        XCTAssertEqual(viewModel.cuisines, ["All", "Italian", "Japanese"])
    }

    func testFetchRecipesFailure() async {
        apiClientMock.result = .failure(APIClientError.requestFailed)

        let expectation = expectation(description: "Recipes empty")
        
        let subscription = viewModel.$filteredRecipes
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }

        viewModel.refresh()

        await fulfillment(of: [expectation], timeout: 2.0)

        XCTAssertTrue(viewModel.filteredRecipes.isEmpty)
    }
    
    func testPresentRecipesUnavailableAlert() async {
        apiClientMock.result = .failure(APIClientError.requestFailed)

        let expectation = expectation(description: "Recipe unavailble alert published")
        
        let subscription = viewModel.presentAlertPublisher
            .sink { alert in
                XCTAssertEqual(alert, RecipesAlert.recipesUnavailable)
                expectation.fulfill()
            }
        
        viewModel.refresh()

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testPresentRecipeSourceValidURL() {
        let recipe = Recipe(cuisine: "Italian", name: "Pasta", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "1", sourceUrl: "https://example.com", youtubeUrl: nil)
        
        let urlExpectation = expectation(description: "Recipe source URL published")
        
        let subscription = viewModel.presentRecipeSourcePublisher
            .sink { url in
                XCTAssertEqual(url, URL(string: "https://example.com"))
                urlExpectation.fulfill()
            }

        viewModel.presentRecipeSource(for: recipe)

        wait(for: [urlExpectation], timeout: 2.0)
    }

    func testPresentRecipeSourceAlert() {
        let recipe = Recipe(cuisine: "Italian", name: "Pasta", photoUrlLarge: nil, photoUrlSmall: nil, uuid: "1", sourceUrl: nil, youtubeUrl: nil)

        let alertExpectation = expectation(description: "Recipe source unavailable alert published")
        
        let subscription = viewModel.presentAlertPublisher
            .sink { alert in
                XCTAssertEqual(alert, RecipesAlert.sourceUnavailable)
                alertExpectation.fulfill()
            }

        viewModel.presentRecipeSource(for: recipe)

        wait(for: [alertExpectation], timeout: 2.0)
    }
}
