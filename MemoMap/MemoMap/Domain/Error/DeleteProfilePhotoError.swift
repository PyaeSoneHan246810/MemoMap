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
            "We couldn’t find your account. Please sign in again."
        case .deleteFailed:
            "Unable to delete your profile photo. Please try again later."
        }
    }
}
