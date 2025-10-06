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
        let userProfile = UserProfileModel(
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
        let firestoreDocumentData = userProfile.firestoreDocumentData
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
            guard let userProfile = try? documentSnapshot.data(as: UserProfileModel.self) else {
                completion(.failure(ListenUserProfileError.getDataFailed))
                return
            }
            let userProfileData = UserProfileData(
                id: userProfile.id,
                emailAddress: userProfile.emailAddress,
                username: userProfile.username,
                displayname: userProfile.displayname,
                profilePhotoUrl: userProfile.profilePhotoUrl,
                coverPhotoUrl: userProfile.coverPhotoUrl,
                birthday: userProfile.birthday,
                bio: userProfile.bio,
                createdAt: userProfile.createdAt
            )
            completion(.success(userProfileData))
            return
        }
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
}
