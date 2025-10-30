//
//  UploadProfilePhotoError.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

enum UploadProfilePhotoError: Error, LocalizedError {
    case uploadFailed
    var errorDescription: String? {
        switch self {
        case .uploadFailed:
            "Unable to upload profile photo. Please try again later."
        }
    }
}
