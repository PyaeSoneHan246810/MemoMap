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
        let memoryModel = MemoryModel(
            id: memoryId,
            pinId: pinId,
            ownerId: userId,
            title: memoryData.title,
            description: memoryData.description,
            media: memoryData.media,
            tags: memoryData.tags,
            dateTime: memoryData.dateTime,
            publicStatus: memoryData.publicStatus,
            locationName: memoryData.locationName,
            location: GeoPoint(latitude: memoryData.latitude, longitude: memoryData.longitude),
            createdAt: memoryData.createdAt
        )
        let firestoreDocumentData = memoryModel.firestoreDocumentData
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
            let memories = self.getMemories(documents: documents)
            completion(.success(memories))
            return
        }
    }
    
    func listenUserPublicMemories(userData: UserData?, completion: @escaping (Result<[MemoryData], any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenUserPublicMemoriesError.userNotFound))
            return
        }
        memoryCollectionReference
            .whereField(MemoryModel.CodingKeys.ownerId.rawValue, isEqualTo: userId)
            .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
            .addSnapshotListener { querySnapshot, error in
                if error != nil {
                    completion(.failure(ListenUserPublicMemoriesError.listenFailed))
                    return
                }
                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }
                let memories = self.getMemories(documents: documents)
                completion(.success(memories))
                return
            }
    }
    
    func addMemoryComment(memoryId: String, commentData: CommentData) async throws {
        let commentDocument = getMemoryCommentsCollectionReference(memoryId: memoryId).document()
        let commentId = commentDocument.documentID
        let commentModel = CommentModel(
            id: commentId,
            comment: commentData.comment,
            userId: commentData.userId,
            createdAt: commentData.createdAt
        )
        let firestoreDocumentData = commentModel.firestoreDocumentData
        do {
            try await commentDocument.setData(firestoreDocumentData, merge: false)
        } catch {
            throw AddMemoryCommentError.addFailed
        }
    }
    
    func loadMemoryComments(memoryId: String) async throws -> [CommentData] {
        do {
            let commentModels = try await getMemoryCommentsCollectionReference(memoryId: memoryId).getDocumentModels(as: CommentModel.self)
            let comments = commentModels.map { commentModel in
                return CommentData(
                    id: commentModel.id,
                    comment: commentModel.comment,
                    userId: commentModel.userId,
                    createdAt: commentModel.createdAt
                )
            }
            return comments
        } catch {
            throw LoadMemoryCommentsError.loadFailed
        }
    }
    
    func addMemoryHeart(memoryId: String, heartData: HeartData) async throws {
        let heartDocument = getMemoryHeartsCollectionReference(memoryId: memoryId).document(heartData.id)
        let heartModel = HeartModel(id: heartData.id, createdAt: heartData.createdAt)
        let firestoreDocumentData = heartModel.firestoreDocumentData
        do {
            try await heartDocument.setData(firestoreDocumentData, merge: false)
        } catch {
            throw AddMemoryHeartError.addFailed
        }
    }
    
    func removeMemeoryHeart(memoryId: String, userId: String) async throws {
        let heartDocument = getMemoryHeartsCollectionReference(memoryId: memoryId).document(userId)
        do {
            try await heartDocument.delete()
        } catch {
            throw RemoveMemoryHeartError.removeFailed
        }
    }
    
    func loadMemoryHearts(memoryId: String) async throws -> [HeartData] {
        do {
            let heartModels = try await getMemoryHeartsCollectionReference(memoryId: memoryId).getDocumentModels(as: HeartModel.self)
            let hearts = heartModels.map { heartModel in
                return HeartData(
                    id: heartModel.id,
                    createdAt: heartModel.createdAt
                )
            }
            return hearts
        } catch {
            throw LoadMemoryHeartsError.loadFailed
        }
    }
    
    func checkIsHeartGiven(memoryId: String, userId: String) async throws -> Bool {
        do {
            let documentSnapshot = try await getMemoryHeartsCollectionReference(memoryId: memoryId).document(userId).getDocument()
            return documentSnapshot.exists
        } catch {
            throw CheckHeartError.checkFailed
        }
    }
    
    func listenCommentsCount(memoryId: String, completion: @escaping (Result<Int, any Error>) -> Void) {
        getMemoryCommentsCollectionReference(memoryId: memoryId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenCountError.listenFailed))
                return
            }
            let commentsCount = querySnapshot?.count ?? 0
            completion(.success(commentsCount))
            return
        }
    }
    
    func listenHeartsCount(memoryId: String, completion: @escaping (Result<Int, any Error>) -> Void) {
        getMemoryHeartsCollectionReference(memoryId: memoryId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenCountError.listenFailed))
                return
            }
            let heartsCount = querySnapshot?.count ?? 0
            completion(.success(heartsCount))
            return
        }
    }
    
    func loadFollowingsPublicMemories(followingIds: [String]) async throws -> [MemoryData] {
        do {
            let memoryModels = try await memoryCollectionReference
                .whereField(MemoryModel.CodingKeys.ownerId.rawValue, in: followingIds)
                .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
                .getDocumentModels(as: MemoryModel.self)
            let memories = memoryModels.map { memoryModel in
                return getMemoryData(from: memoryModel)
            }
            return memories
        } catch {
            throw LoadFollowingsPublicMemoriesError.loadFailed
        }
    }
    
    func getTotalHeartsCount(userData: UserData?) async throws -> Int {
        guard let userId = userData?.uid else {
            throw GetTotalHeartsCountError.userNotFound
        }
        return try await getTotoalHeartsCount(userId: userId)
    }
    
    func getTotoalHeartsCount(userId: String) async throws -> Int {
        var totalHeartsCount: Int = 0
        do {
            let publicMemoryModels = try await memoryCollectionReference
                .whereField(MemoryModel.CodingKeys.ownerId.rawValue, isEqualTo: userId)
                .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
                .getDocumentModels(as: MemoryModel.self)
            for publicMemoryModel in publicMemoryModels {
                let memoryId = publicMemoryModel.id
                let countQuery = getMemoryHeartsCollectionReference(memoryId: memoryId).count
                let countQuerySnapshot = try? await countQuery.getAggregation(source: .server)
                let heartsCount = countQuerySnapshot?.count.intValue ?? 0
                totalHeartsCount += heartsCount
            }
            return totalHeartsCount
        } catch {
            throw GetTotalHeartsCountError.failedToGet
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
    
    func getMemoryCommentsCollectionReference(memoryId: String) -> CollectionReference {
        memoryCollectionReference.document(memoryId).collection("comments")
    }
    
    func getMemoryHeartsCollectionReference(memoryId: String) -> CollectionReference {
        memoryCollectionReference.document(memoryId).collection("hearts")
    }
    
    func getMemories(documents: [QueryDocumentSnapshot]) -> [MemoryData] {
        let memoryModels: [MemoryModel] = documents.compactMap { documentSnapshot in
            try? documentSnapshot.data(as: MemoryModel.self)
        }
        let memories: [MemoryData] = memoryModels.map { memoryModel in
            return getMemoryData(from: memoryModel)
        }
        return memories
    }
    
    func getMemoryData(from memoryModel: MemoryModel) -> MemoryData {
        return MemoryData(
            id: memoryModel.id,
            pinId: memoryModel.pinId,
            ownerId: memoryModel.ownerId,
            title: memoryModel.title,
            description: memoryModel.description,
            media: memoryModel.media,
            tags: memoryModel.tags,
            dateTime: memoryModel.dateTime,
            publicStatus: memoryModel.publicStatus,
            locationName: memoryModel.locationName,
            latitude: memoryModel.location.latitude,
            longitude: memoryModel.location.longitude,
            createdAt: memoryModel.createdAt
        )
    }
}
