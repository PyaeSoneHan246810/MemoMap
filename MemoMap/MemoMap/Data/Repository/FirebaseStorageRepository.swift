//
//  FirebaseStorageRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseStorage

final class FirebaseStorageRepository: StorageRepository {
    
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

private extension FirebaseStorageRepository {
    var storage: Storage {
        Storage.storage()
    }
    
    var storageRefernce: StorageReference {
        storage.reference()
    }
    
    var profilesStorageRefernce: StorageReference {
        storageRefernce.child("profiles")
    }
    
    func getUserProfilePhotoStorageRefernce(userId: String) -> StorageReference {
        profilesStorageRefernce.child(userId)
    }
}
