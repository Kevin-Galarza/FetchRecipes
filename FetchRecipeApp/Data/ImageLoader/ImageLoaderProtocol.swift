//
//  ImageLoaderProtocol.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/30/24.
//

import UIKit

protocol ImageLoaderProtocol {
    func loadImage(id: String, url: String) async -> UIImage?
}
