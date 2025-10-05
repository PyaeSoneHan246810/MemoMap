//
//  FirebaseUserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseUserProfileRepository: UserProfileRepository {
    
    func saveUserProfile(userProfileData: UserProfileData, userData: UserData) async throws {
        let userId = userData.uid
        let userProfile = UserProfileModel(
            id: userId,
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
            try await getUserCollectionDocumentReference(userId: userId)
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
