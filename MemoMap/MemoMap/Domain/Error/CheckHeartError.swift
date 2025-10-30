//
//  CheckHeartError.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation

enum CheckHeartError: Error, LocalizedError {
    case checkFailed
    var errorDescription: String? {
        switch self {
        case .checkFailed:
            "Unable to verify whether you’ve already given a heart. Please try again later."
        }
    }
}
