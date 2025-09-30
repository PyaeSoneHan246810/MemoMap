//
//  StorageRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseStorage

protocol StorageRepository {
    func uploadProfilePhoto(data: Data, userId: String) async throws -> String
}
