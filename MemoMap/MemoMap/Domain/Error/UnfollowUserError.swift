//
//  UnfollowUserError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum UnfollowUserError: Error, LocalizedError {
    case userNotFound
    case unfollowFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .unfollowFailed:
            "Unable to unfollow the user. Please try again later."
        }
    }
}
