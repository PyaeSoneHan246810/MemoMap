//
//  UpdateUserProfileInfoError.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import Foundation

enum UpdateUserProfileInfoError: Error, LocalizedError {
    case updateFailed
    case unknownError
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Update Failed"
        case .unknownError:
            "Unknown Error"
        }
    }
}
