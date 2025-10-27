//
//  GetFollowersError.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation

enum GetFollowersError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Failed To Get"
        }
    }
}
