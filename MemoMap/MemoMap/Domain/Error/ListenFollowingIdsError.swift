//
//  ListenFollowingIdsError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum ListenFollowingIdsError: Error, LocalizedError {
    case userNotFound
    case listenFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .listenFailed:
            "Unable to listen the following ids. Please try again later."
        }
    }
}
