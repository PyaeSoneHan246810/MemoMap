//
//  GetPinsError.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import Foundation

enum GetPinsError: Error, LocalizedError {
    case userNotFound
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Found"
        case .failedToGet:
            "Failed To Get"
        }
    }
}
