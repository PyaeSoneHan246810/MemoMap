//
//  ListenCountError.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

enum ListenCountError: Error, LocalizedError {
    case userNotFound
    case listenFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .listenFailed:
            "Unable to listen the count. Please try again later."
        }
    }
}
