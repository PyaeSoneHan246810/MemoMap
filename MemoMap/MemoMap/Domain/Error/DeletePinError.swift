//
//  DeletePinError.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

enum DeletePinError: Error, LocalizedError {
    case deleteFailed
    var errorDescription: String? {
        switch self {
        case .deleteFailed:
            "Delete Failed"
        }
    }
}
