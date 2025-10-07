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
    
    func listenPinMemories(pinId: String, completion: @escaping (Result<[MemoryData], any Error>) -> Void) {
        memoryCollectionReference.whereField(MemoryModel.CodingKeys.pinId.rawValue, isEqualTo: pinId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenPinMemoriesError.listenFailed))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let memoryModels: [MemoryModel] = documents.compactMap { documentSnapshot in
                try? documentSnapshot.data(as: MemoryModel.self)
            }
            let memories: [MemoryData] = memoryModels.map { memoryModel in
                return MemoryData(
                    id: memoryModel.id,
                    title: memoryModel.title,
                    description: memoryModel.description,
                    media: memoryModel.media,
                    tags: memoryModel.tags,
                    dateTime: memoryModel.dateTime,
                    publicStatus: memoryModel.publicStatus,
                    createdAt: memoryModel.createdAt
                )
            }
            completion(.success(memories))
            return
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
