//
//  DeleteCoverPhotoError.swift
//  MemoMap
//
//  Created by Dylan on 28/10/25.
//

import Foundation

enum DeleteCoverPhotoError: Error, LocalizedError {
    case userNotFound
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            "We couldn’t find your account. Please sign in again."
        case .deleteFailed:
            "Unable to delete your profile photo. Please try again later."
        }
    }
}
