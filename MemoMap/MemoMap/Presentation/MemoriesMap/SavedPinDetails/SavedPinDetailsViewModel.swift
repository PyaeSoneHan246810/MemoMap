//
//  SavedPinDetailsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import SwiftUI
import PhotosUI
import Observation
import Factory

@Observable
final class SavedPinDetailsViewModel {
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.pinRepository) private var pinRepository: PinRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    private(set) var pinDataState: DataState<PinData> = .initial
    
    private(set) var memories: [MemoryData] = []
    
    var newPinPhotoPickerItem: PhotosPickerItem? = nil
    
    var newPinPhoto: UIImage? = nil
    
    var newPinName: String = ""
    
    var newPinDescription: String = ""
    
    var isEditPinSheetPresented: Bool = false
    
    var pin: PinData? {
        if case .success(let data) = pinDataState {
            return data
        } else {
            return nil
        }
    }
    
    var trimmedNewPinName: String {
        newPinName.trimmed()
    }
    
    var trimmedNewPinDescription: String {
        newPinDescription.trimmed()
    }
    
    func getPin(for pinId: String) async {
        pinDataState = .loading
        do {
            let pin = try await pinRepository.getPin(pinId: pinId)
            pinDataState = .success(pin)
        } catch {
            if let getPinError = error as? GetPinError {
                let errorDescription = getPinError.localizedDescription
                print(errorDescription)
                pinDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                pinDataState = .failure(errorDescription)
            }
        }
    }
    
    func getMemories(for pinId: String) async {
        do {
            let memories = try await memoryRepository.getPinMemories(pinId: pinId)
            self.memories = memories
        } catch {
            if let getPinMemoriesError = error as? GetPinMemoriesError {
                print(getPinMemoriesError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func updatePinPhoto(for pinId: String) async {
        guard let data = newPinPhoto?.jpegData(compressionQuality: 1.0) else {
            return
        }
        do {
            let newPinPhotoUrl = try await storageRepository.uploadPinPhoto(data: data, pinId: pinId)
            try await pinRepository.updatePinPhotoUrl(pinId: pinId, pinPhotoUrlString: newPinPhotoUrl)
            await getPin(for: pinId)
        } catch {
            if let uploadPinPhotoError = error as? UploadPinPhotoError {
                print(uploadPinPhotoError.localizedDescription)
            } else if let updatePinPhotoError = error as? UploadPinPhotoError {
                print(updatePinPhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func editPinInfo(for pinId: String) async {
        do {
            try await pinRepository.updatePinInfo(pinId: pinId, pinName: trimmedNewPinName, pinDescription: trimmedNewPinDescription)
            try await memoryRepository.updateMemoriesPinInfo(pinId: pinId, pinName: trimmedNewPinName)
            await getPin(for: pinId)
            isEditPinSheetPresented = false
        } catch {
            if let updatePinInfoError = error as? UpdatePinInfoError {
                print(updatePinInfoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func deletePin(for pinId: String, onSuccess: () -> Void) async {
        do {
            try await pinRepository.deletePin(pinId: pinId)
            try await memoryRepository.deletePinMemories(pinId: pinId)
            onSuccess()
        } catch {
            if let deletePinError = error as? DeletePinError {
                print(deletePinError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteMemory(for memoryId: String) async {
        do {
            try await memoryRepository.deleteMemory(memoryId: memoryId)
            try await storageRepository.deleteMemoryMedia(memoryId: memoryId)
            memories.removeAll {
                $0.id == memoryId
            }
        } catch {
            if let deleteMemoryError = error as? DeleteMemoryError {
                print(deleteMemoryError.localizedDescription)
            } else if let deleteMemoryMediaError = error as? DeleteMemoryMediaError {
                print(deleteMemoryMediaError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
