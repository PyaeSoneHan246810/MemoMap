//
//  UploadPinPhotoError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum UploadPinPhotoError: Error, LocalizedError {
    case uploadFailed
    var errorDescription: String? {
        switch self {
        case .uploadFailed:
            "Unable to upload the photo. Please try again later."
        }
    }
}
