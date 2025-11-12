//
//  GetFollowingsPublicMemoriesError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum GetFollowingsPublicMemoriesError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load memories. Please try again later."
        }
    }
}
