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
    
    func getMediaList(from mediaUrlStrings: [String]) {
        mediaList = mediaUrlStrings.map { mediaUrlString in
            let mediaType: MediaType = mediaUrlString.contains(".jpeg") ? .image : .video
            return Media(
                type: mediaType,
                urlString: mediaUrlString
            )
        }
    }
    
    func addNewMemoryMediaItems(for memoryId: String, onComplete: () -> Void) async {
        var uploadedMemoryMediaUrlStrings: [String] = []
        do {
            uploadedMemoryMediaUrlStrings = await uploadNewMemoryMediaItems(memoryId: memoryId)
            if !uploadedMemoryMediaUrlStrings.isEmpty {
                try await memoryRepository.updateMemoryMedia(memoryId: memoryId, media: uploadedMemoryMediaUrlStrings)
            }
            onComplete()
        } catch {
            if let updateMemoryMediaError = error as? UpdateMemoryMediaError {
                print(updateMemoryMediaError.localizedDescription)
                if case .updateFailed = updateMemoryMediaError {
                    for urlString in uploadedMemoryMediaUrlStrings {
                        await deleteMemoryMediaStorageItem(urlString: urlString)
                    }
                }
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadNewMemoryMediaItems(memoryId: String) async -> [String] {
        var uploadedMemoryMediaUrlStrings: [String] = []
        do {
            for memoryMediaItem in newMemoryMediaItems {
                let fileName = memoryMediaItem.id.uuidString
                switch memoryMediaItem.media {
                case .image(let uiImage):
                    if let data = uiImage.jpegData(compressionQuality: 1.0) {
                        let memoryPhotoUrlString = try await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId)
                        uploadedMemoryMediaUrlStrings.append(memoryPhotoUrlString)
                    }
                case .video(let movie):
                    let url = movie.url
                    let memoryVideoUrlString = try await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId)
                    uploadedMemoryMediaUrlStrings.append(memoryVideoUrlString)
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
        return uploadedMemoryMediaUrlStrings
    }
    
    func deleteMemoryMedia(memoryId: String, media: Media, onComplete: () -> Void) async {
        do {
            try await memoryRepository.removeMemoryMedia(memoryId: memoryId, mediaToRemove: media.urlString)
            await deleteMemoryMediaStorageItem(urlString: media.urlString)
            self.mediaList.removeAll {
                $0.urlString == media.urlString
            }
            onComplete()
        } catch {
            if let removeMemoryMediaError = error as? RemoveMemoryMediaError {
                print(removeMemoryMediaError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteMemoryMediaStorageItem(urlString: String) async {
        do {
            try await storageRepository.deleteMemoryMediaItem(with: urlString)
        } catch {
            if let deleteMemoryMediaItemError = error as? DeleteMemoryMediaItemError {
                print(deleteMemoryMediaItemError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllMemoryMedia(memoryId: String, onComplete: () -> Void) async {
        do {
            try await memoryRepository.removeAllMemoryMedia(memoryId: memoryId)
            await deleteAllMemoryMediaStorageItems(for: memoryId)
            self.mediaList.removeAll()
            onComplete()
        } catch {
            if let removeAllMemoryMediaError = error as? RemoveAllMemoryMediaError {
                print(removeAllMemoryMediaError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func deleteAllMemoryMediaStorageItems(for memoryId: String) async {
        do {
            try await storageRepository.deleteMemoryMedia(memoryId: memoryId)
        } catch {
            if let deleteMemoryMediaError = error as? DeleteMemoryMediaError {
                print(deleteMemoryMediaError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func addNewMemoryMediaItem(for memoryId: String, completion: () -> Void) async {
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
            completion()
        } catch {
            if let addMemoryMediaError = error as? AddMemoryMediaError {
                print(addMemoryMediaError.localizedDescription)
                if case .addFailed = addMemoryMediaError, let urlString = uploadedMemoryMediaUrlString {
                    await deleteMemoryMediaStorageItem(urlString: urlString)
                }
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadNewMemoryMediaItem(memoryId: String) async -> String? {
        guard let memoryMediaItem = newMemoryMediaItem else {
            return nil
        }
        var uploadedMemoryMediaUrlString: String? = nil
        do {
            let fileName = memoryMediaItem.id.uuidString
            switch memoryMediaItem.media {
            case .image(let uiImage):
                if let data = uiImage.jpegData(compressionQuality: 1.0) {
                    let memoryPhotoUrlString = try await storageRepository.uploadMemoryPhoto(data: data, fileName: fileName, memoryId: memoryId)
                    uploadedMemoryMediaUrlString = memoryPhotoUrlString
                }
            case .video(let movie):
                let url = movie.url
                let memoryVideoUrlString = try await storageRepository.uploadMemoryVideo(url: url, fileName: fileName, memoryId: memoryId)
                uploadedMemoryMediaUrlString = memoryVideoUrlString
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
        return uploadedMemoryMediaUrlString
    }
    
}
