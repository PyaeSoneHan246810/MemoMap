//
//  UsernameAvailabilityError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum UsernameAvailabilityError: Error, LocalizedError {
    case taken
    var errorDescription: String? {
        switch self {
        case .taken:
            "This username is already taken. Please choose another one."
        }
    }
}
