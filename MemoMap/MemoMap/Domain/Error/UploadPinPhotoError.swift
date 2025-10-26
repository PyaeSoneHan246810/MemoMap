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
            "Upload Failed"
        }
    }
}
