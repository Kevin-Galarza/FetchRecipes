//
//  MockImageLoader.swift
//  FetchRecipeAppTests
//
//  Created by Kevin Galarza on 12/30/24.
//

import UIKit
@testable import FetchRecipeApp

final class MockImageLoader: ImageLoaderProtocol {
    func loadImage(id: String, url: String) async -> UIImage? {
        return UIImage(systemName: "carrot")
    }
}
