//
//  SaveUserProfileError.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

enum SaveUserProfileError: Error, LocalizedError {
    case saveFailed
    var errorDescription: String? {
        switch self {
        case .saveFailed:
            "Unable to save your profile. Please try again."
        }
    }
}
