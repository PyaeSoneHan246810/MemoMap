//
//  SearchMemoriesError.swift
//  MemoMap
//
//  Created by Dylan on 16/10/25.
//

import Foundation

enum SearchMemoriesError: Error, LocalizedError {
    case searchFailed
    var errorDescription: String? {
        switch self {
        case .searchFailed:
            "Unable to search memories. Please try again later."
        }
    }
}
