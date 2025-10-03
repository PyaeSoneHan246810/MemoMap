//
//  DeleteProfilePhotoError.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation

enum DeleteProfilePhotoError: Error {
    case userNotFound
    case deleteFailed
    case unknownError
}
