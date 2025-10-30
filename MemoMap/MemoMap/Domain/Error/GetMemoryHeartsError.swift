//
//  GetMemoryHeartsError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum GetMemoryHeartsError: Error, LocalizedError {
    case failedToGet
    var errorDescription: String? {
        switch self {
        case .failedToGet:
            "Unable to load the hearts for this memory. Please try again later."
        }
    }
}
