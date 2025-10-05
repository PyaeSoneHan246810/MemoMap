//
//  FirebaseMemoryRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseMemoryRepository: MemoryRepository {
    func saveMemory(memoryData: MemoryData, pinId: String, userData: UserData?) async throws -> String {
        guard let userId = userData?.uid else {
            throw SaveMemoryError.userNotFound
        }
        let memoryDocument = memoryCollectionReference.document()
        let memoryId = memoryDocument.documentID
        let memory = MemoryModel(
            id: memoryId,
            pinId: pinId,
            ownerId: userId,
            title: memoryData.title,
            description: memoryData.description,
            media: memoryData.media,
            tags: memoryData.tags,
            dateTime: memoryData.dateTime,
            publicStatus: memoryData.publicStatus,
            createdAt: memoryData.createdAt
        )
        let firestoreDocumentData = memory.firestoreDocumentData
        do {
            try await memoryDocument.setData(firestoreDocumentData, merge: false)
            return memoryId
        } catch {
            throw SaveMemoryError.saveFailed
        }
    }
    
    func updateMemoryMedia(memoryId: String, media: [String]) async throws {
        let updatedData = [
            MemoryModel.CodingKeys.media.rawValue: media
        ]
        do {
            try await memoryCollectionReference.document(memoryId).updateData(updatedData)
        } catch {
            throw UpdateMemoryMediaError.updateFailed
        }
    }
}

private extension FirebaseMemoryRepository {
    var firestoreDatabase: Firestore {
        Firestore.firestore()
    }
    
    var memoryCollectionReference: CollectionReference {
        firestoreDatabase.collection("memories")
    }
}
