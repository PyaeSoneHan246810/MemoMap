//
//  UploadMemoryVideoError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum UploadMemoryVideoError: Error, LocalizedError {
    case uploadFailed
    var errorDescription: String? {
        switch self {
        case .uploadFailed:
            "Unable to upload memory video. Please try again later."
        }
    }
}
