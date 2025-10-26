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
    
    private var userData: UserData? {
        authenticationRepository.getUserData()
    }
    
    var isChooseLocationViewPresented: Bool = false
    
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
    
    var selectedPin: PinData? = nil
    
    private(set) var isPostMemoryInProgress: Bool = false
    
    private(set) var saveMemoryError: SaveMemoryError? = nil
    
    var isSaveMemoryAlertPresented: Bool = false
    
    func postMemory(onSuccess: () -> Void) async {
        guard let pin = selectedPin else { return }
        isPostMemoryInProgress = true
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
            isPostMemoryInProgress = false
            saveMemoryError = nil
            isSaveMemoryAlertPresented = false
            onSuccess()
        } catch {
            isPostMemoryInProgress = false
            if let saveMemeoryError = error as? SaveMemoryError {
                self.saveMemoryError = saveMemeoryError
            } else {
                saveMemoryError = .saveFailed
            }
            isSaveMemoryAlertPresented = true
        }
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
}
