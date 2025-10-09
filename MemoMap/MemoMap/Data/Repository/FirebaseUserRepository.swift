//
//  FirebaseUserRepository.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    func followUser(userId: String, userToFollowId: String) async throws {
        let batch = firestoreDatabase.batch()
        let newFollowingDocument = getUserFollowingsCollectionReference(userId: userId).document(userToFollowId)
        let newFollowerDocument = getUserFollowersCollectionReference(userId: userToFollowId).document(userId)
        let followingModel = FollowingModel(id: userToFollowId, since: .now)
        let followerModel = FollowerModel(id: userId, since: .now)
        batch.setData(followingModel.firestoreDocumentData, forDocument: newFollowingDocument)
        batch.setData(followerModel.firestoreDocumentData, forDocument: newFollowerDocument)
        do {
            try await batch.commit()
        } catch {
            throw FollowUserError.followFailed
        }
    }
    
    func unfollowUser(userId: String, userToUnfollowId: String) async throws {
        let batch = firestoreDatabase.batch()
        let followingDocument = getUserFollowingsCollectionReference(userId: userId).document(userToUnfollowId)
        let followerDocument = getUserFollowersCollectionReference(userId: userToUnfollowId).document(userId)
        batch.deleteDocument(followingDocument)
        batch.deleteDocument(followerDocument)
        do {
            try await batch.commit()
        } catch {
            throw UnfollowUserError.unfollowFailed
        }
    }
}

private extension FirebaseUserRepository {
    var firestoreDatabase: Firestore {
        Firestore.firestore()
    }
    
    var userCollectionReference: CollectionReference {
        firestoreDatabase.collection("users")
    }
    
    func getUserFollowingsCollectionReference(userId: String) -> CollectionReference {
        userCollectionReference.document(userId).collection("followings")
    }
    
    func getUserFollowersCollectionReference(userId: String) -> CollectionReference {
        userCollectionReference.document(userId).collection("followers")
    }
}
