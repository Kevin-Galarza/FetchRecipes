//
//  StorageType.swift
//  FetchRecipeApp
//
//  Created by Kevin Galarza on 12/23/24.
//

import Foundation

enum StorageType: Sendable {
    /// Stores data in user's `caches` directory, which is volatile.
    case temporary
    /// Stores data in user's `documents` directory.
    case permanent
}
