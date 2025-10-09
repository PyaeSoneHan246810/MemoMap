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
        let pinModel = PinModel(
            id: pinId,
            ownerId: userId,
            name: pinData.name,
            description: pinData.description,
            photoUrl: pinData.photoUrl,
            location: GeoPoint(latitude: pinData.latitude, longitude: pinData.longitude),
            createdAt: pinData.createdAt
        )
        let firestoreDocumentData = pinModel.firestoreDocumentData
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
    
    func listenPins(userData: UserData?, completion: @escaping (Result<[PinData], any Error>) -> Void) {
        guard let userId = userData?.uid else {
            completion(.failure(ListenPinsError.userNotFound))
            return
        }
        pinCollectionReference.whereField(PinModel.CodingKeys.ownerId.rawValue, isEqualTo: userId).addSnapshotListener { querySnapshot, error in
            if error != nil {
                completion(.failure(ListenPinsError.listenFailed))
                return
            }
            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }
            let pinModels: [PinModel] = documents.compactMap { documentSnapshot in
                try? documentSnapshot.data(as: PinModel.self)
            }
            let pins: [PinData] = pinModels.map { pinModel in
                return PinData(
                    id: pinModel.id,
                    name: pinModel.name,
                    description: pinModel.description,
                    photoUrl: pinModel.photoUrl,
                    latitude: pinModel.location.latitude,
                    longitude: pinModel.location.longitude,
                    createdAt: pinModel.createdAt
                )
            }
            completion(.success(pins))
            return
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
