//
//  AddNewPinViewModel.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import SwiftUI
import Observation
import PhotosUI
import Factory

@Observable
final class AddNewPinViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.pinRepository) private var pinRepository: PinRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    var locationPhotoPickerItem: PhotosPickerItem? = nil
    
    var locationPhotoImage: UIImage? = nil
    
    var locationName: String = ""
    
    var locationDescription: String = ""
    
    var memoryMediaItems: [MemoryMediaItem] = []
    
    var memoryTitle: String = ""
    
    var memoryDescription: String = ""
    
    var memoryTags: [String] = []
    
    var memoryDateTime: Date = .now
    
    var isMemoryPublic: Bool = true
    
    private var trimmedLocationName: String {
        locationName.trimmed()
    }
    
    private var trimmedLocationDescription: String {
        locationDescription.trimmed()
    }
    
    private var trimmedMemoryTitle: String {
        memoryTitle.trimmed()
    }
    
    private var trimmedMemoryDescription: String {
        memoryDescription.trimmed()
    }
    
    private(set) var savePinError: SavePinError? = nil
    
    private(set) var saveMemoryError: SaveMemoryError? = nil
    
    func saveNewPin(latitude: Double, longitude: Double) async -> Result<Void, Error> {
        let pinData = PinData(
            id: "",
            name: trimmedLocationName,
            description: trimmedLocationDescription.isEmpty ? nil : trimmedLocationDescription,
            photoUrl: nil,
            latitude: latitude,
            longitude: longitude,
            createdAt: .now
        )
        let userData = authenticationRepository.getUserData()
        var savedPinId: String? = nil
        do {
            savedPinId = try await pinRepository.savePin(pinData: pinData, userData: userData)
            if let savedPinId {
                if let pinPhotoUrlString = await uploadPinPhoto(pinId: savedPinId) {
                    await updatePinPhotoUrl(pinId: savedPinId, pinPhotoUrlString: pinPhotoUrlString)
                }
                let savedMemoryId = try await saveMemory(
                    pinId: savedPinId,
                    locationName: trimmedLocationName,
                    latitude: latitude,
                    longitude: longitude,
                    userData: userData
                )
                let uploadedMemoryMedia = await uploadMemoryMedia(memoryId: savedMemoryId)
                if !uploadedMemoryMedia.isEmpty {
                    await updateMemoryMedia(memoryId: savedMemoryId, media: uploadedMemoryMedia)
                }
            }
            return .success(())
        } catch {
            if let savePinError = error as? SavePinError {
                print(savePinError.localizedDescription)
                self.savePinError = savePinError
                return .failure(savePinError)
            } else if let saveMemeoryError = error as? SaveMemoryError {
                print(saveMemeoryError.localizedDescription)
                self.saveMemoryError = saveMemeoryError
                if let savedPinId {
                    await deletePin(pinId: savedPinId)
                    await deletePinPhoto(pinId: savedPinId)
                }
                return .failure(saveMemeoryError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
    
    private func uploadPinPhoto(pinId: String) async -> String? {
        guard let locationPhotoImage, let data = locationPhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let pinPhotoUrlString = try await storageRepository.uploadPinPhoto(data: data, pinId: pinId)
            return pinPhotoUrlString
        } catch {
            if let uploadPinPhotoError = error as? UploadPinPhotoError {
                print(uploadPinPhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func updatePinPhotoUrl(pinId: String, pinPhotoUrlString: String) async {
        do {
            try await pinRepository.updatePinPhotoUrl(pinId: pinId, pinPhotoUrlString: pinPhotoUrlString)
        } catch {
            if let updatePinPhotoUrlError = error as? UpdatePinPhotoUrlError {
                print(updatePinPhotoUrlError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func saveMemory(pinId: String, locationName: String, latitude: Double, longitude: Double, userData: UserData?) async throws -> String {
        let memoryData = MemoryData(
            id: "",
            pinId: "",
            ownerId: "",
            title: trimmedMemoryTitle,
            description: trimmedMemoryDescription,
            media: [],
            tags: memoryTags,
            dateTime: memoryDateTime,
            publicStatus: isMemoryPublic,
            locationName: locationName,
            latitude: latitude,
            longitude: longitude,
            createdAt: .now
        )
        let memoryId = try await memoryRepository.saveMemory(memoryData: memoryData, pinId: pinId, userData: userData)
        return memoryId
    }
    
    private func uploadMemoryMedia(memoryId: String) async -> [String] {
        var uploadedMemoryMedia: [String] = []
        do {
            for memoryMediaItem in memoryMediaItems {
                let fileName = memoryMediaItem.id.uuidString
                switch memoryMediaItem.media {
                case .image(let uiImage):
                    if let data = uiImage.jpegData(compressionQuality: 1.0) {
                        let memoryPhotoUrlString = try await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId)
                        uploadedMemoryMedia.append(memoryPhotoUrlString)
                    }
                case .video(let movie):
                    let url = movie.url
                    let memoryVideoUrlString = try await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId)
                    uploadedMemoryMedia.append(memoryVideoUrlString)
                }
            }
        } catch {
            if let uploadMemoryPhotoError = error as? UploadMemoryPhotoError {
                print(uploadMemoryPhotoError.localizedDescription)
            } else if let uploadMemoryVideoError = error as? UploadMemoryVideoError {
                print(uploadMemoryVideoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
        return uploadedMemoryMedia
    }
    
    private func updateMemoryMedia(memoryId: String, media: [String]) async {
        do {
            try await memoryRepository.updateMemoryMedia(memoryId: memoryId, media: media)
        } catch {
            if let updateMemoryMediaError = error as? UpdateMemoryMediaError {
                print(updateMemoryMediaError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deletePin(pinId: String) async {
        do {
            try await pinRepository.deletePin(pinId: pinId)
        } catch {
            if let deletePinError = error as? DeletePinError {
                print(deletePinError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deletePinPhoto(pinId: String) async {
        do {
            try await storageRepository.deletePinPhoto(pinId: pinId)
        } catch {
            if let deletePinPhotoError = error as? DeletePinPhotoError {
                print(deletePinPhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
