//
//  FirebaseUserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseFirestore

final class FirebaseUserProfileRepository: UserProfileRepository {
    private let firestoreDatabase: Firestore = Firestore.firestore()
    
    private var userCollectionReference: CollectionReference {
        firestoreDatabase.collection("users")
    }
    
    private func getUserCollectionDocumentReference(userId: String) -> DocumentReference {
        userCollectionReference.document(userId)
    }
    
    func saveUserProfile(userProfile: UserProfileModel) async throws {
        let userId = userProfile.id
        let firestoreDocumentData = userProfile.firestoreDocumentData
        do {
            try await getUserCollectionDocumentReference(userId: userId)
                .setData(firestoreDocumentData, merge: false)
        } catch {
            throw SaveUserProfileError.databaseError
        }
    }
}
