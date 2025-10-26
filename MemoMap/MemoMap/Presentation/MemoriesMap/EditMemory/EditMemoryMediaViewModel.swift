//
//  EditMemoryMediaViewModel.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import SwiftUI
import PhotosUI
import Observation
import Factory

@Observable
class EditMemoryMediaViewModel {
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var mediaList: [Media] = []
    
    var newMemoryMediaItems: [MemoryMediaItem] = []
    
    var newMemoryMediaItem: MemoryMediaItem? = nil
    
    var newMemoryMediaPhotoPickerItem: PhotosPickerItem? = nil
    
    private(set) var isAddingNewItemsInProgress: Bool = false
    
    private(set) var isAddingNewItemInProgress: Bool = false
    
    private(set) var isDeleteItemInProgress: Bool = false
    
    private(set) var isDeleteAllItemsInProgress: Bool = false
    
    private(set) var updateMemoryMediaError: UpdateMemoryMediaError? = nil
    
    private(set) var addMemoryMediaError: AddMemoryMediaError? = nil
    
    private(set) var removeAllMemoryMediaError: RemoveAllMemoryMediaError? = nil
    
    var isAddingNewItemsAlertPresented: Bool = false
    
    var isAddingNewItemAlertPresented: Bool = false
    
    var isDeleteAllItemsAlertPresented: Bool = false
    
    func getMediaList(from mediaUrlStrings: [String]) {
        mediaList = mediaUrlStrings.map { mediaUrlString in
            let mediaType: MediaType = mediaUrlString.contains(".jpeg") ? .image : .video
            return Media(
                type: mediaType,
                urlString: mediaUrlString
            )
        }
    }
    
    func addNewMemoryMediaItems(for memoryId: String, onSuccess: () -> Void) async {
        isAddingNewItemsInProgress = true
        var uploadedMemoryMediaUrlStrings: [String] = []
        do {
            uploadedMemoryMediaUrlStrings = await uploadNewMemoryMediaItems(memoryId: memoryId)
            if !uploadedMemoryMediaUrlStrings.isEmpty {
                try await memoryRepository.updateMemoryMedia(memoryId: memoryId, media: uploadedMemoryMediaUrlStrings)
            }
            isAddingNewItemsInProgress = false
            updateMemoryMediaError = nil
            isAddingNewItemsAlertPresented = false
            onSuccess()
        } catch {
            isAddingNewItemsInProgress = false
            if let updateMemoryMediaError = error as? UpdateMemoryMediaError {
                if case .updateFailed = updateMemoryMediaError {
                    for urlString in uploadedMemoryMediaUrlStrings {
                        await deleteMemoryMediaStorageItem(urlString: urlString)
                    }
                }
                self.updateMemoryMediaError = updateMemoryMediaError
            } else {
                updateMemoryMediaError = .updateFailed
            }
            isAddingNewItemsAlertPresented = true
        }
    }
    
    private func uploadNewMemoryMediaItems(memoryId: String) async -> [String] {
        var uploadedMemoryMediaUrlStrings: [String] = []
        for memoryMediaItem in newMemoryMediaItems {
            let fileName = memoryMediaItem.id.uuidString
            switch memoryMediaItem.media {
            case .image(let uiImage):
                if let data = uiImage.jpegData(compressionQuality: 1.0) {
                    if let memoryPhotoUrlString = try? await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId) {
                        uploadedMemoryMediaUrlStrings.append(memoryPhotoUrlString)
                    }
                }
            case .video(let movie):
                let url = movie.url
                if let memoryVideoUrlString = try? await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId) {
                    uploadedMemoryMediaUrlStrings.append(memoryVideoUrlString)
                }
            }
        }
        return uploadedMemoryMediaUrlStrings
    }
    
    private func deleteMemoryMediaStorageItem(urlString: String) async {
        try? await storageRepository.deleteMemoryMediaItem(with: urlString)
    }
    
    func deleteMemoryMedia(memoryId: String, media: Media, onSuccess: () -> Void) async {
        isDeleteItemInProgress = true
        do {
            try await memoryRepository.removeMemoryMedia(memoryId: memoryId, mediaToRemove: media.urlString)
            await deleteMemoryMediaStorageItem(urlString: media.urlString)
            mediaList.removeAll {
                $0.urlString == media.urlString
            }
            isDeleteItemInProgress = false
            onSuccess()
        } catch {
            print(error.localizedDescription)
            isDeleteItemInProgress = false
        }
    }
    
    func deleteAllMemoryMedia(memoryId: String, onSuccess: () -> Void) async {
        isDeleteAllItemsInProgress = true
        do {
            try await memoryRepository.removeAllMemoryMedia(memoryId: memoryId)
            await deleteAllMemoryMediaStorageItems(for: memoryId)
            mediaList.removeAll()
            isDeleteAllItemsInProgress = false
            removeAllMemoryMediaError = nil
            isDeleteAllItemsAlertPresented = false
            onSuccess()
        } catch {
            isDeleteAllItemsInProgress = false
            if let removeAllMemoryMediaError = error as? RemoveAllMemoryMediaError {
                self.removeAllMemoryMediaError = removeAllMemoryMediaError
            } else {
                removeAllMemoryMediaError = .removeFailed
            }
            isDeleteAllItemsAlertPresented = true
        }
    }
    
    private func deleteAllMemoryMediaStorageItems(for memoryId: String) async {
        try? await storageRepository.deleteMemoryMedia(memoryId: memoryId)
    }
    
    func addNewMemoryMediaItem(for memoryId: String, onSuccess: () -> Void) async {
        isAddingNewItemInProgress = true
        var uploadedMemoryMediaUrlString: String? = nil
        do {
            uploadedMemoryMediaUrlString = await uploadNewMemoryMediaItem(memoryId: memoryId)
            try await memoryRepository.addMemoryMedia(memoryId: memoryId, media: uploadedMemoryMediaUrlString)
            if let urlString = uploadedMemoryMediaUrlString, let mediaType = newMemoryMediaItem?.media {
                switch mediaType {
                case .image(_):
                    let newMediaAdded = Media(type: .image, urlString: urlString)
                    mediaList.append(newMediaAdded)
                case .video(_):
                    let newMediaAdded = Media(type: .video, urlString: urlString)
                    mediaList.append(newMediaAdded)
                }
            }
            isAddingNewItemInProgress = false
            addMemoryMediaError = nil
            isAddingNewItemAlertPresented = false
            onSuccess()
        } catch {
            isAddingNewItemInProgress = false
            if let addMemoryMediaError = error as? AddMemoryMediaError {
                if case .addFailed = addMemoryMediaError, let urlString = uploadedMemoryMediaUrlString {
                    await deleteMemoryMediaStorageItem(urlString: urlString)
                }
                self.addMemoryMediaError = addMemoryMediaError
            } else {
                addMemoryMediaError = .addFailed
            }
            isAddingNewItemAlertPresented = true
        }
    }
    
    private func uploadNewMemoryMediaItem(memoryId: String) async -> String? {
        guard let memoryMediaItem = newMemoryMediaItem else {
            return nil
        }
        var uploadedMemoryMediaUrlString: String? = nil
        let fileName = memoryMediaItem.id.uuidString
        switch memoryMediaItem.media {
        case .image(let uiImage):
            if let data = uiImage.jpegData(compressionQuality: 1.0) {
                if let memoryPhotoUrlString = try? await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId) {
                    uploadedMemoryMediaUrlString = memoryPhotoUrlString
                }
            }
        case .video(let movie):
            let url = movie.url
            if let memoryVideoUrlString = try? await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId) {
                uploadedMemoryMediaUrlString = memoryVideoUrlString
            }
        }
        return uploadedMemoryMediaUrlString
    }
    
}
