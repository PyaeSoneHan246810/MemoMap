//
//  UpdatePinPhotoUrlError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum UpdatePinPhotoUrlError: Error, LocalizedError {
    case updateFailed
    var errorDescription: String? {
        switch self {
        case .updateFailed:
            "Unable to update the photo. Please try again later."
        }
    }
}
