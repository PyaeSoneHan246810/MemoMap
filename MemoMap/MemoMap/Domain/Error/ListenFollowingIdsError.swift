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
            "User Not Found"
        case .listenFailed:
            "Listen Failed"
        }
    }
}
