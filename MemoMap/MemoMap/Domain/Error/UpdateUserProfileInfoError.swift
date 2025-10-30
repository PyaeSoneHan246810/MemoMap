//
//  UpdateUserProfileInfoError.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import Foundation

enum UpdateUserProfileInfoError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update your profile information. Please try again."
        }
    }
}
