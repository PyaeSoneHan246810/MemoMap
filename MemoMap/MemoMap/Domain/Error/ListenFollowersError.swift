//
//  ListenFollowersError.swift
//  MemoMap
//
//  Created by Dylan on 12/10/25.
//

import Foundation

enum ListenFollowersError: Error, LocalizedError {
    case userNotFound
    case listenFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .listenFailed:
            "Unable to listen the followers. Please try again later."
        }
    }
}
