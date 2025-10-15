//
//  FirebaseUserRepository.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseUserRepository: UserRepository {
    func followUser(userData: UserData?, userToFollowId: String) async throws {
        guard let userId = userData?.uid else {
            throw FollowUserError.userNotFound
        }
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
    
    func unfollowUser(userData: UserData?, userToUnfollowId: String) async throws {
        guard let userId = userData?.uid else {
            throw UnfollowUserError.userNotFound
        }
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
    
    func listenFollowingIds(userData: UserData?, completion: @escaping (Result<[String], any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenFollowingIdsError.userNotFound))
            return
        }
        getUserFollowingsCollectionReference(userId: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenFollowingIdsError.listenFailed))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let followingIds = documents.map { documentSnapshot in
                documentSnapshot.documentID
            }
            completion(.success(followingIds))
            return
        }
    }
    
    func searchUsers(searchText: String) async throws -> [UserProfileData] {
        let lowercasedSearchText = searchText.lowercased()
        let queryByUsername = userCollectionReference
            .whereField(UserProfileModel.CodingKeys.usernameLowercased.rawValue, isGreaterThanOrEqualTo: lowercasedSearchText)
            .whereField(UserProfileModel.CodingKeys.usernameLowercased.rawValue, isLessThanOrEqualTo: lowercasedSearchText + "\u{f8ff}")
        let queryByDisplayname = userCollectionReference
            .whereField(UserProfileModel.CodingKeys.displaynameLowercased.rawValue, isGreaterThanOrEqualTo: lowercasedSearchText)
            .whereField(UserProfileModel.CodingKeys.displaynameLowercased.rawValue, isLessThanOrEqualTo: lowercasedSearchText + "\u{f8ff}")
        async let querySnapshotByUsername = queryByUsername.getDocuments()
        async let querySnapshotByDisplayname = queryByDisplayname.getDocuments()
        do {
            let (documentsByUsername, documentsByDisplayname) = try await (querySnapshotByUsername, querySnapshotByDisplayname)
            let userProfileModelsByUsername = documentsByUsername.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserProfileModel.self)
            }
            let userProfileModelsByDisplayname = documentsByDisplayname.documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: UserProfileModel.self)
            }
            let allUserProfileModels = userProfileModelsByUsername + userProfileModelsByDisplayname
            let uniqueUserProfileModels = Dictionary(grouping: allUserProfileModels, by: \.id).compactMap { $0.value.first }
            let uniqueUsers = uniqueUserProfileModels.map { userProfileModel in
                getUserProfileData(from: userProfileModel)
            }
            return uniqueUsers
        } catch {
            throw SearchUsersError.searchFailed
        }
    }
    
    func listenFollowingsCount(userData: UserData?, completion: @escaping (Result<Int, any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenCountError.userNotFound))
            return
        }
        getUserFollowingsCollectionReference(userId: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenCountError.listenFailed))
                return
            }
            let followingsCount = querySnapshot?.count ?? 0
            completion(.success(followingsCount))
            return
        }
    }
    
    func listenFollowersCount(userData: UserData?, completion: @escaping (Result<Int, any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenCountError.userNotFound))
            return
        }
        getUserFollowersCollectionReference(userId: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenCountError.listenFailed))
                return
            }
            let followersCount = querySnapshot?.count ?? 0
            completion(.success(followersCount))
            return
        }
    }
    
    func listenFollowings(userData: UserData?, completion: @escaping (Result<[FollowingData], any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenFollowingsError.userNotFound))
            return
        }
        getUserFollowingsCollectionReference(userId: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenFollowingsError.listenFailed))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let followingModels = documents.compactMap { documentSnapshot in
                try? documentSnapshot.data(as: FollowingModel.self)
            }
            let followings = followingModels.map { followingModel in
                FollowingData(id: followingModel.id, since: followingModel.since)
            }
            completion(.success(followings))
            return
        }
    }
    
    func listenFollowers(userData: UserData?, completion: @escaping (Result<[FollowerData], any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenFollowersError.userNotFound))
            return
        }
        getUserFollowersCollectionReference(userId: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenFollowersError.listenFailed))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let followerModels = documents.compactMap { documentSnapshot in
                try? documentSnapshot.data(as: FollowerModel.self)
            }
            let followers = followerModels.map { followerModel in
                FollowerData(id: followerModel.id, since: followerModel.since)
            }
            completion(.success(followers))
            return
        }
    }
    
    func getFollowingsCount(userId: String) async throws -> Int {
        do {
            let countQuery = getUserFollowingsCollectionReference(userId: userId).count
            let countSnapshot = try await countQuery.getAggregation(source: .server)
            let followingsCount = countSnapshot.count.intValue
            return followingsCount
        } catch {
            throw GetCountError.failedToGet
        }
        
    }
    
    func getFollowersCount(userId: String) async throws -> Int {
        do {
            let countQuery = getUserFollowersCollectionReference(userId: userId).count
            let countSnapshot = try await countQuery.getAggregation(source: .server)
            let followersCount = countSnapshot.count.intValue
            return followersCount
        } catch {
            throw GetCountError.failedToGet
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
    
    func getUserProfileData(from userProfileModel: UserProfileModel) -> UserProfileData {
        return UserProfileData(
            id: userProfileModel.id,
            emailAddress: userProfileModel.emailAddress,
            username: userProfileModel.username,
            displayname: userProfileModel.displayname,
            profilePhotoUrl: userProfileModel.profilePhotoUrl,
            coverPhotoUrl: userProfileModel.coverPhotoUrl,
            birthday: userProfileModel.birthday,
            bio: userProfileModel.bio,
            createdAt: userProfileModel.createdAt
        )
    }
}
