//
//  GetPinError.swift
//  MemoMap
//
//  Created by Dylan on 16/10/25.
//

import Foundation

enum GetPinError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load the pin. Please try again later."
        }
    }
}
