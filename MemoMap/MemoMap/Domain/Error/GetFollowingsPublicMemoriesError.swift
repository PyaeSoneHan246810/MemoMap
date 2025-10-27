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
            "Failed To Get"
        }
    }
}
