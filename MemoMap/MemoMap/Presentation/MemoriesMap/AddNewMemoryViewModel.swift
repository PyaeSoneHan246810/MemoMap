//
//  AddNewMemoryViewModel.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import SwiftUI
import Observation
import Factory

@Observable
final class AddNewMemoryViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    var memoryMediaItems: [MemoryMediaItem] = []
    
    var memoryTitle: String = ""
    
    var memoryDescription: String = ""
    
    var memoryTags: [String] = []
    
    var memoryDateTime: Date = .now
    
    var isMemoryPublic: Bool = true
    
    private(set) var saveMemoryError: SaveMemoryError? = nil
    
    private var trimmedMemoryTitle: String {
        memoryTitle.trimmed()
    }
    
    private var trimmedMemoryDescription: String {
        memoryDescription.trimmed()
    }
    
    func saveMemory(pin: PinData) async -> Result<Void, Error> {
        let userData = authenticationRepository.getUserData()
        let memoryData: MemoryData = .init(
            id: "",
            pinId: "",
            ownerId: "",
            title: trimmedMemoryTitle,
            description: trimmedMemoryDescription,
            media: [],
            tags: memoryTags,
            dateTime: memoryDateTime,
            publicStatus: isMemoryPublic,
            locationName: pin.name,
            latitude: pin.latitude,
            longitude: pin.longitude,
            createdAt: .now
        )
        do {
            let savedMemoryId = try await memoryRepository.saveMemory(memoryData: memoryData, pinId: pin.id, userData: userData)
            let uploadedMemoryMedia = await uploadMemoryMedia(memoryId: savedMemoryId)
            if !uploadedMemoryMedia.isEmpty {
                await updateMemoryMedia(memoryId: savedMemoryId, media: uploadedMemoryMedia)
            }
            return .success(())
        } catch {
            if let saveMemeoryError = error as? SaveMemoryError {
                print(saveMemeoryError.localizedDescription)
                self.saveMemoryError = saveMemeoryError
                return .failure(saveMemeoryError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
    
    private func uploadMemoryMedia(memoryId: String) async -> [String] {
        var uploadedMemoryMedia: [String] = []
        do {
            for (id, memoryMediaItem) in memoryMediaItems.enumerated() {
                let fileName = "media_\(id + 1)"
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
}
