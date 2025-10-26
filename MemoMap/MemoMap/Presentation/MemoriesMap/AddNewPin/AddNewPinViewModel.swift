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
    
    var userData: UserData? {
        authenticationRepository.getUserData()
    }
    
    var locationPhotoPickerItem: PhotosPickerItem? = nil
    
    var locationPhotoImage: UIImage? = nil
    
    var locationName: String = ""
    
    private var trimmedLocationName: String {
        locationName.trimmed()
    }
    
    var locationDescription: String = ""
    
    private var trimmedLocationDescription: String {
        locationDescription.trimmed()
    }
    
    var memoryMediaItems: [MemoryMediaItem] = []
    
    var memoryTitle: String = ""
    
    private var trimmedMemoryTitle: String {
        memoryTitle.trimmed()
    }
    
    var memoryDescription: String = ""
    
    private var trimmedMemoryDescription: String {
        memoryDescription.trimmed()
    }
    
    var memoryTags: [String] = []
    
    var memoryDateTime: Date = .now
    
    var isMemoryPublic: Bool = true
    
    private(set) var isSaveNewPinInProgress: Bool = false
    
    enum SaveNewPinError: Error, LocalizedError {
        case savePinError(SavePinError)
        case saveMemoryError(SaveMemoryError)
        case unknownError
        var errorDescription: String? {
            switch self {
            case .savePinError(let savePinError):
                savePinError.localizedDescription
            case .saveMemoryError(let saveMemoryError):
                saveMemoryError.localizedDescription
            case .unknownError:
                "Unknown Error"
            }
        }
    }
    
    private(set) var saveNewPinError: SaveNewPinError? = nil
    
    var isSaveNewPinAlertPresented: Bool = false
    
    func saveNewPin(latitude: Double, longitude: Double, onSuccess: () -> Void) async {
        isSaveNewPinInProgress = true
        let pinData = PinData(
            id: "",
            name: trimmedLocationName,
            description: trimmedLocationDescription.isEmpty ? nil : trimmedLocationDescription,
            photoUrl: nil,
            latitude: latitude,
            longitude: longitude,
            createdAt: .now
        )
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
            isSaveNewPinInProgress = false
            saveNewPinError = nil
            isSaveNewPinAlertPresented = false
            onSuccess()
        } catch {
            isSaveNewPinInProgress = false
            if let savePinError = error as? SavePinError {
                saveNewPinError = .savePinError(savePinError)
            } else if let saveMemeoryError = error as? SaveMemoryError {
                if let savedPinId {
                    await deletePin(pinId: savedPinId)
                    await deletePinPhoto(pinId: savedPinId)
                }
                saveNewPinError = .saveMemoryError(saveMemeoryError)
            } else {
                saveNewPinError = .unknownError
            }
        }
    }
    
    private func uploadPinPhoto(pinId: String) async -> String? {
        guard let locationPhotoImage, let data = locationPhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let pinPhotoUrlString = try? await storageRepository.uploadPinPhoto(data: data, pinId: pinId)
        return pinPhotoUrlString
    }
    
    private func updatePinPhotoUrl(pinId: String, pinPhotoUrlString: String) async {
        try? await pinRepository.updatePinPhotoUrl(pinId: pinId, pinPhotoUrlString: pinPhotoUrlString)
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
        for memoryMediaItem in memoryMediaItems {
            let fileName = memoryMediaItem.id.uuidString
            switch memoryMediaItem.media {
            case .image(let uiImage):
                if let data = uiImage.jpegData(compressionQuality: 1.0) {
                    if let memoryPhotoUrlString = try? await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId) {
                        uploadedMemoryMedia.append(memoryPhotoUrlString)
                    }
                }
            case .video(let movie):
                let url = movie.url
                if let memoryVideoUrlString = try? await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId) {
                    uploadedMemoryMedia.append(memoryVideoUrlString)
                }
            }
        }
        return uploadedMemoryMedia
    }
    
    private func updateMemoryMedia(memoryId: String, media: [String]) async {
        try? await memoryRepository.updateMemoryMedia(memoryId: memoryId, media: media)
    }
    
    private func deletePin(pinId: String) async {
        try? await pinRepository.deletePin(pinId: pinId)
    }
    
    private func deletePinPhoto(pinId: String) async {
        try? await storageRepository.deletePinPhoto(pinId: pinId)
    }
}
