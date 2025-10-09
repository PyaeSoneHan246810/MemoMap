//
//  FirebaseUserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseUserProfileRepository: UserProfileRepository {
    
    func saveUserProfile(userProfileData: UserProfileData) async throws {
        let id = userProfileData.id
        let userProfileModel = UserProfileModel(
            id: id,
            emailAddress: userProfileData.emailAddress,
            username: userProfileData.username,
            displayname: userProfileData.displayname,
            profilePhotoUrl: userProfileData.profilePhotoUrl,
            coverPhotoUrl: userProfileData.coverPhotoUrl,
            birthday: userProfileData.birthday,
            bio: userProfileData.bio,
            createdAt: userProfileData.createdAt
        )
        let firestoreDocumentData = userProfileModel.firestoreDocumentData
        do {
            try await getUserCollectionDocumentReference(userId: id)
                .setData(firestoreDocumentData, merge: false)
        } catch {
            throw SaveUserProfileError.saveFailed
        }
    }
    
    func checkUsernameAvailability(username: String) async throws {
        do {
            let querySnapshot = try await userCollectionReference
                .whereField(UserProfileModel.CodingKeys.username.rawValue, isEqualTo: username)
                .getDocuments()
            let isUsernameAvaliable = querySnapshot.documents.isEmpty
            guard isUsernameAvaliable else {
                throw UsernameAvailabilityError.taken
            }
        } catch {
            throw UsernameAvailabilityError.failedToCheck
        }
    }
    
    func deleteUserProfile(userData: UserData?) async throws {
        guard let userId = userData?.uid else {
            throw DeleteUserProfileError.userNotFound
        }
        do {
            try await getUserCollectionDocumentReference(userId: userId).delete()
        } catch {
            throw DeleteUserProfileError.deleteFailed
        }
    }
    
    func listenUserProfile(userData: UserData?, completion: @escaping (Result<UserProfileData, Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenUserProfileError.userNotFound))
            return
        }
        getUserCollectionDocumentReference(userId: userId).addSnapshotListener { documentSnapshot, error in
            if error != nil {
                completion(.failure(ListenUserProfileError.listenFailed))
                return
            }
            guard let documentSnapshot else {
                completion(.failure(ListenUserProfileError.documentNotFound))
                return
            }
            guard let userProfileModel = try? documentSnapshot.data(as: UserProfileModel.self) else {
                completion(.failure(ListenUserProfileError.getDataFailed))
                return
            }
            let userProfile = self.getUserProfileData(from: userProfileModel)
            completion(.success(userProfile))
            return
        }
    }
    
    func getUserProfile(userId: String) async throws -> UserProfileData {
        let userProfileModel = try await getUserCollectionDocumentReference(userId: userId).getDocument(as: UserProfileModel.self)
        let userProfile = getUserProfileData(from: userProfileModel)
        return userProfile
    }
    
}

private extension FirebaseUserProfileRepository {
    var firestoreDatabase: Firestore {
        Firestore.firestore()
    }
    
    var userCollectionReference: CollectionReference {
        firestoreDatabase.collection("users")
    }
    
    func getUserCollectionDocumentReference(userId: String) -> DocumentReference {
        userCollectionReference.document(userId)
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
