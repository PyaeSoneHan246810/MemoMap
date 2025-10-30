//
//  FollowUserError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum FollowUserError: Error, LocalizedError {
    case userNotFound
    case followFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .followFailed:
            "Unable to follow the user. Please try again later."
        }
    }
}
