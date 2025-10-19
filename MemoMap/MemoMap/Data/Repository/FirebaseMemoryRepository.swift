//
//  FirebaseMemoryRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore
import Factory

final class FirebaseMemoryRepository: MemoryRepository {
    @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
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
            locationNameLowercased: memoryData.locationName.lowercased(),
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
    
    func getPinMemories(pinId: String) async throws -> [MemoryData] {
        do {
            let memoryModels = try await memoryCollectionReference.whereField(MemoryModel.CodingKeys.pinId.rawValue, isEqualTo: pinId).getDocumentModels(as: MemoryModel.self)
            let memories = memoryModels.map { memoryModel in
                getMemoryData(from: memoryModel)
            }
            return memories
        } catch {
            throw GetPinMemoriesError.failedToGet
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
    
    func getMemoryComments(memoryId: String) async throws -> [CommentData] {
        do {
            let commentModels = try await getMemoryCommentsCollectionReference(memoryId: memoryId).getDocumentModels(as: CommentModel.self)
            let comments = commentModels.map { commentModel in
                CommentData(
                    id: commentModel.id,
                    comment: commentModel.comment,
                    userId: commentModel.userId,
                    createdAt: commentModel.createdAt
                )
            }
            return comments
        } catch {
            throw GetMemoryCommentsError.failedToGet
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
    
    func getMemoryHearts(memoryId: String) async throws -> [HeartData] {
        do {
            let heartModels = try await getMemoryHeartsCollectionReference(memoryId: memoryId).getDocumentModels(as: HeartModel.self)
            let hearts = heartModels.map { heartModel in
                HeartData(
                    id: heartModel.id,
                    createdAt: heartModel.createdAt
                )
            }
            return hearts
        } catch {
            throw GetMemoryHeartsError.failedToGet
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
    
    func getFollowingsPublicMemories(followingIds: [String]) async throws -> [MemoryData] {
        do {
            let memoryModels = try await memoryCollectionReference
                .whereField(MemoryModel.CodingKeys.ownerId.rawValue, in: followingIds)
                .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
                .getDocumentModels(as: MemoryModel.self)
            let memories = memoryModels.map { memoryModel in
                getMemoryData(from: memoryModel)
            }
            return memories
        } catch {
            throw GetFollowingsPublicMemoriesError.failedToGet
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
    
    func getUserPublicMemories(userData: UserData?) async throws -> [MemoryData] {
        guard let userId = userData?.uid else {
            throw GetUserPublicMemoriesError.userNotFound
        }
        return try await getUserPublicMemories(userId: userId)
    }
    
    func getUserPublicMemories(userId: String) async throws -> [MemoryData] {
        do {
            let memoryModels = try await memoryCollectionReference
                .whereField(MemoryModel.CodingKeys.ownerId.rawValue, isEqualTo: userId)
                .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
                .getDocumentModels(as: MemoryModel.self)
            let memories = memoryModels.map { memoryModel in
                getMemoryData(from: memoryModel)
            }
            return memories
        } catch {
            throw GetUserPublicMemoriesError.failedToGet
        }
    }
    
    func searchMemoriesByLocationName(locationName: String) async throws -> [MemoryData] {
        do {
            let locationNameLowercased = locationName.lowercased()
            let memoryModels = try await memoryCollectionReference
                .whereField(MemoryModel.CodingKeys.publicStatus.rawValue, isEqualTo: true)
                .whereField(MemoryModel.CodingKeys.locationNameLowercased.rawValue, isGreaterThanOrEqualTo: locationNameLowercased)
                .whereField(MemoryModel.CodingKeys.locationNameLowercased.rawValue, isLessThanOrEqualTo: locationNameLowercased + "\u{f8ff}")
                .getDocumentModels(as: MemoryModel.self)
            let memories = memoryModels.map { memoryModel in
                getMemoryData(from: memoryModel)
            }
            return memories
        } catch {
            throw SearchMemoriesError.searchFailed
        }
    }
    
    func updateMemoriesPinInfo(pinId: String, pinName: String) async throws {
        do {
            let updatedData = [
                MemoryModel.CodingKeys.locationName.rawValue: pinName,
                MemoryModel.CodingKeys.locationNameLowercased.rawValue: pinName.lowercased()
            ]
            let querySnapshot = try await memoryCollectionReference.whereField(MemoryModel.CodingKeys.pinId.rawValue, isEqualTo: pinId).getDocuments()
            for document in querySnapshot.documents {
                try? await document.reference.updateData(updatedData)
            }
        } catch {
            throw UpdatePinInfoError.updateFailed
        }
    }
    
    func deletePinMemories(pinId: String) async throws {
        do {
            let querySnapshot = try await memoryCollectionReference.whereField(MemoryModel.CodingKeys.pinId.rawValue, isEqualTo: pinId).getDocuments()
            for document in querySnapshot.documents {
                let memoryId = document.documentID
                try? await document.reference.delete()
                try? await storageRepository.deleteMemoryMedia(memoryId: memoryId)
            }
        } catch {
            throw DeletePinError.deleteFailed
        }
    }
    
    func deleteMemory(memoryId: String) async throws {
        do {
            try await memoryCollectionReference.document(memoryId).delete()
        } catch {
            throw DeleteMemoryError.deleteFailed
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
