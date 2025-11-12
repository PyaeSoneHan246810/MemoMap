//
//  AddMemoryMediaError.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

enum AddMemoryMediaError: Error, LocalizedError {
    case mediaNotExist
    case addFailed
    var errorDescription: String? {
        switch self {
        case .mediaNotExist:
            "The media file doesn’t exist. Please check and try again."
        case .addFailed:
            "Unable to add the memory media. Please try again later."
        }
    }
}
