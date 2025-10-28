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
            "We couldn’t find your account. Please sign in again."
        case .failedToGet:
            "Unable to load your pins. Please try again later."
        }
    }
}
