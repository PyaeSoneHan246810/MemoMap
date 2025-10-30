//
//  GetFollowingsError.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation

enum GetFollowingsError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load the followings. Please try again later."
        }
    }
}
