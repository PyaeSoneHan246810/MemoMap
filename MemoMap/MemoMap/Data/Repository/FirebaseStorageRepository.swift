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
            let profilePhotoReference = getUserProfilePhotoStorageRefernce(userId: userId)
            let _ = try await profilePhotoReference.putDataAsync(data, metadata: metaData)
            let downloadUrl = try await profilePhotoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadProfilePhotoError.uploadFailed
        }
    }
    
    func deleteProfilePhoto(user: UserModel?) async throws {
        guard let userId = user?.uid else {
            throw DeleteProfilePhotoError.userNotFound
        }
        do {
            try await getUserProfilePhotoStorageRefernce(userId: userId).delete()
        } catch {
            throw DeleteProfilePhotoError.deleteFailed
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
        profilesStorageRefernce.child(userId).child(profilePhotoPath)
    }
    
    var profilePhotoPath: String {
        "profile.jpeg"
    }
}
