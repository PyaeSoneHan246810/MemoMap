//
//  UploadMemoryPhotoError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum UploadMemoryPhotoError: Error {
    case uploadFailed
    var errorDescription: String? {
        switch self {
        case .uploadFailed:
            "Unable to upload memory photo. Please try again later."
        }
    }
}
