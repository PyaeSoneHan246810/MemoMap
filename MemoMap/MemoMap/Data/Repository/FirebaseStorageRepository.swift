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
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let profilePhotoReference = getProfilePhotoStorageRefernce(userId: userId)
        do {
            let _ = try await profilePhotoReference.putDataAsync(data, metadata: metaData)
            let downloadUrl = try await profilePhotoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadProfilePhotoError.uploadFailed
        }
    }
    
    func deleteProfilePhoto(userData: UserData?) async throws {
        guard let userId = userData?.uid else {
            throw DeleteProfilePhotoError.userNotFound
        }
        do {
            try await getProfilePhotoStorageRefernce(userId: userId).delete()
        } catch {
            throw DeleteProfilePhotoError.deleteFailed
        }
    }
    
    func uploadPinPhoto(data: Data, pinId: String) async throws -> String {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let pinPhotoReference = getPinPhotoStorageReference(pinId: pinId)
        do {
            let _ = try await pinPhotoReference.putDataAsync(data, metadata: metaData)
            let downloadUrl = try await pinPhotoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadPinPhotoError.uploadFailed
        }
    }
    
    func deletePinPhoto(pinId: String) async throws {
        do {
            try await getPinPhotoStorageReference(pinId: pinId).delete()
        } catch {
            throw DeletePinPhotoError.deleteFailed
        }
    }
    
    func uploadMemoryPhoto(data: Data, fileName: String, memoryId: String) async throws -> String {
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        let memoryPhotoReference = getMemoryMediaStorageReference(memoryId: memoryId, path: "\(fileName).jpeg")
        do {
            let _ = try await memoryPhotoReference.putDataAsync(data, metadata: metaData)
            let downloadUrl = try await memoryPhotoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadMemoryPhotoError.uploadFailed
        }
    }
    
    func uploadMemoryVideo(url: URL, fileName: String, memoryId: String) async throws -> String {
        let metaData = StorageMetadata()
        metaData.contentType = "video/mp4"
        let memoryVideoReference = getMemoryMediaStorageReference(memoryId: memoryId, path: "\(fileName).mp4")
        do {
            let _ = try await memoryVideoReference.putFileAsync(from: url, metadata: metaData)
            let downloadUrl = try await memoryVideoReference.downloadURL()
            let downloadUrlString = downloadUrl.absoluteString
            return downloadUrlString
        } catch {
            throw UploadMemoryVideoError.uploadFailed
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
    
    var pinsStorageReference: StorageReference {
        storageRefernce.child("pins")
    }
    
    var memoriesStorageReference: StorageReference {
        storageRefernce.child("memories")
    }
    
    var profilePhotoPath: String {
        "profile.jpeg"
    }
    
    var pinPhotoPath: String {
        "pin.jpeg"
    }
    
    func getProfilePhotoStorageRefernce(userId: String) -> StorageReference {
        profilesStorageRefernce.child(userId).child(profilePhotoPath)
    }
    
    func getPinPhotoStorageReference(pinId: String) -> StorageReference {
        pinsStorageReference.child(pinId).child(pinPhotoPath)
    }
    
    func getMemoryMediaStorageReference(memoryId: String, path: String) -> StorageReference {
        memoriesStorageReference.child(memoryId).child(path)
    }

}
