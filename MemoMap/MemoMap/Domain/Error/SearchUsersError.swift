//
//  SearchUsersError.swift
//  MemoMap
//
//  Created by Dylan on 11/10/25.
//

import Foundation

enum SearchUsersError: Error, LocalizedError {
    case searchFailed
    var errorDescription: String? {
        switch self {
        case .searchFailed:
            "Unable to search users. Please try again later."
        }
    }
}
