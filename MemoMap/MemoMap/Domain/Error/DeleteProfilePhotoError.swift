//
//  DeleteProfilePhotoError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum DeleteProfilePhotoError: Error, LocalizedError {
    case userNotFound
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "User Not Foun"
        case .deleteFailed:
            "Delete Failed"
        }
    }
}
