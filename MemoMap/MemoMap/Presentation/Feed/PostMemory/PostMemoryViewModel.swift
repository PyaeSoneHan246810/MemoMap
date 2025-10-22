//
//  PostMemoryViewModel.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import SwiftUI
import Observation
import Factory

@Observable
class PostMemoryViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    var isChooseLocationViewPresented: Bool = false
    
    var memoryMediaItems: [MemoryMediaItem] = []
    
    var memoryTitle: String = ""
    
    var memoryDescription: String = ""
    
    var memoryTags: [String] = []
    
    var memoryDateTime: Date = .now
    
    var selectedPin: PinData? = nil
    
    var trimmedMemoryTitle: String {
        memoryTitle.trimmed()
    }
    
    var trimmedMemoryDescription: String {
        memoryDescription.trimmed()
    }
    
    func postMemory(onComplete: () -> Void) async {
        guard let pin = selectedPin else { return }
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
            publicStatus: true,
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
            onComplete()
        } catch {
            if let saveMemeoryError = error as? SaveMemoryError {
                print(saveMemeoryError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
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
}
