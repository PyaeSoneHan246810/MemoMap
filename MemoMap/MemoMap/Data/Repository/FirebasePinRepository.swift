//
//  FirebasePinRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation
import FirebaseFirestore
import Factory

final class FirebasePinRepository: PinRepository {
    @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
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
            try await storageRepository.deletePinPhoto(pinId: pinId)
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
                self.getPinData(from: pinModel)
            }
            completion(.success(pins))
            return
        }
    }
    
    func getPin(pinId: String) async throws -> PinData {
        do {
            let pinModel = try await pinCollectionReference.document(pinId).getDocument(as: PinModel.self)
            let pin = getPinData(from: pinModel)
            return pin
        } catch {
            throw GetPinError.failedToGet
        }
    }
    
    func updatePinInfo(pinId: String, pinName: String, pinDescription: String?) async throws {
        let updatedData = [
            PinModel.CodingKeys.name.rawValue: pinName,
            PinModel.CodingKeys.description.rawValue: pinDescription as Any
        ]
        do {
            try await pinCollectionReference.document(pinId).updateData(updatedData)
        } catch {
            throw UpdatePinInfoError.updateFailed
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
    
    func getPinData(from pinModel: PinModel) -> PinData {
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
}
