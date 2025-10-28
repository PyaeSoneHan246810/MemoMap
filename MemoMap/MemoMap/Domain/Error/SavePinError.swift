//
//  SavePinError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum SavePinError: Error, LocalizedError {
    case userNotFound
    case saveFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .saveFailed:
            "Unable to save the pin. Please try again later."
        }
    }
}
