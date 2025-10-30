//
//  DeletePinPhotoError.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation

enum DeletePinPhotoError: Error, LocalizedError {
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .deleteFailed:
            "Unable to delete the pin photo. Please try again later."
        }
    }
}
