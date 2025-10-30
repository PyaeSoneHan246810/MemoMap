//
//  ListenUserProfileError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum ListenUserProfileError: Error, LocalizedError {
    case userNotFound
    case listenFailed
    case documentNotFound
    case getDataFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .listenFailed:
            "Unable to listen the user profile. Please try again later."
        case .documentNotFound:
            "Document Not Found"
        case .getDataFailed:
            "Get Data Failed"
        }
    }
}
