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
    
    func uploadCoverPhoto(data: Data, userId: String) async throws -> String
    
    func deleteProfilePhoto(userData: UserData?) async throws
    
    func deleteCoverPhoto(userData: UserData?) async throws
    
    func uploadPinPhoto(data: Data, pinId: String) async throws -> String
    
    func deletePinPhoto(pinId: String) async throws
    
    func uploadMemoryPhoto(data: Data, fileName: String, memoryId: String) async throws -> String
    
    func uploadMemoryVideo(url: URL, fileName: String, memoryId: String) async throws -> String
    
    func deleteMemoryMedia(memoryId: String) async throws
    
    func deleteMemoryMediaItem(with urlString: String) async throws
}
