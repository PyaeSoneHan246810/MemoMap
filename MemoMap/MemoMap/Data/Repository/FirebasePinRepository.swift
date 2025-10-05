//
//  FirebasePinRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore

final class FirebasePinRepository: PinRepository {
    func savePin(pinData: PinData, userData: UserData?) async throws -> String {
        guard let userId = userData?.uid else {
            throw SavePinError.userNotFound
        }
        let pinDocument = pinCollectionReference.document()
        let pinId = pinDocument.documentID
        let pin = PinModel(
            id: pinId,
            ownerId: userId,
            name: pinData.name,
            description: pinData.description,
            photoUrl: pinData.photoUrl,
            latitude: pinData.latitude,
            longitude: pinData.longitude,
            createdAt: pinData.createdAt
        )
        let firestoreDocumentData = pin.firestoreDocumentData
        do {
            try await pinDocument.setData(firestoreDocumentData, merge: false)
            return pinId
        } catch {
            throw SavePinError.saveFailed
        }
    }
    
    func updatePinPhotoUrl(pinId: String, pinPhotoUrlString: String) async throws {
        let updatedData = [
            PinModel.CodingKeys.photoUrl.rawValue: pinPhotoUrlString
        ]
        do {
            try await pinCollectionReference.document(pinId).updateData(updatedData)
        } catch {
            throw UpdatePinPhotoUrlError.updateFailed
        }
    }
    
    func deletePin(pinId: String) async throws {
        do {
            try await pinCollectionReference.document(pinId).delete()
        } catch {
            throw DeletePinError.deleteFailed
        }
    }
}

private extension FirebasePinRepository {
    var firestoreDatabase: Firestore {
        Firestore.firestore()
    }
    
    var pinCollectionReference: CollectionReference {
        firestoreDatabase.collection("pins")
    }
}
