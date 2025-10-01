//
//  FirebaseStorageRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageRepository: StorageRepository {
    private let storage: Storage = Storage.storage()
    
    private var storageRefernce: StorageReference {
        storage.reference()
    }
    
    private var profilesStorageRefernce: StorageReference {
        storageRefernce.child("profiles")
    }
    
    private func getUserProfilePhotoStorageRefernce(userId: String) -> StorageReference {
        profilesStorageRefernce.child(userId)
    }
    
    func uploadProfilePhoto(data: Data, userId: String) async throws -> String {
        do {
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            let profilePhotoPath = "profile.jpeg"
            let profilePhotoReference = getUserProfilePhotoStorageRefernce(userId: userId).child(profilePhotoPath)
            let _ = try await profilePhotoReference.putDataAsync(data, metadata: metaData)
            let downloadUrl = try await profilePhotoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadProfilePhotoError.uploadFailed
        }
    }
}
