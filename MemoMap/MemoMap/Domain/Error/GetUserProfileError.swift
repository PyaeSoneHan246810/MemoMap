//
//  GetUserProfileError.swift
//  MemoMap
//
//  Created by Dylan on 14/10/25.
//

import Foundation

enum GetUserProfileError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load the user profile. Please try again later."
        }
    }
}
