//
//  GetUserPublicMemoriesError.swift
//  MemoMap
//
//  Created by Dylan on 14/10/25.
//

import Foundation

enum GetUserPublicMemoriesError: Error, LocalizedError {
    case userNotFound
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .failedToGet:
            "Unable to load memories. Please try again later."
        }
    }
}
