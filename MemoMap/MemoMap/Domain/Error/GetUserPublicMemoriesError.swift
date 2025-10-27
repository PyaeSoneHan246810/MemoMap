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
            "User Not Found"
        case .failedToGet:
            "Failed To Get"
        }
    }
}
