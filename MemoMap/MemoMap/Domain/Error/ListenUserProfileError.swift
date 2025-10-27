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
            "User Not Found"
        case .listenFailed:
            "Listen Failed"
        case .documentNotFound:
            "Document Not Found"
        case .getDataFailed:
            "Get Data Failed"
        }
    }
}
