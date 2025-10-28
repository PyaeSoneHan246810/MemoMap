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
    
    private var userData: UserData? {
        authenticationRepository.getUserData()
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
    
    var isSaveMemoryValid: Bool {
        !trimmedMemoryTitle.isEmpty
    }
    
    private(set) var isSaveMemoryInProgress: Bool = false
    
    private(set) var saveMemoryError: SaveMemoryError? = nil
    
    var isSaveMemoryAlertPresented: Bool = false
    
    func saveMemory(pin: PinData, onSuccess: () -> Void) async {
        isSaveMemoryInProgress = true
        let memoryData: MemoryData = .init(
            id: "",
            pinId: "",
            ownerId: "",
            title: trimmedMemoryTitle,
            description: trimmedMemoryDescription.isEmpty ? nil : trimmedMemoryDescription,
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
            isSaveMemoryInProgress = false
            saveMemoryError = nil
            isSaveMemoryAlertPresented = false
            onSuccess()
        } catch {
            isSaveMemoryInProgress = true
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
