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
    
    var pin: PinData? {
        if case .success(let data) = pinDataState {
            return data
        } else {
            return nil
        }
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
    
    var isEditPinSheetPresented: Bool = false
    
    var newPinPhotoPickerItem: PhotosPickerItem? = nil
    
    var newPinPhoto: UIImage? = nil
    
    var newPinName: String = ""
    
    private var trimmedNewPinName: String {
        newPinName.trimmed()
    }
    
    var newPinDescription: String = ""
    
    private var trimmedNewPinDescription: String {
        newPinDescription.trimmed()
    }
    
    private(set) var isEditPinPhotoInProgress: Bool = false
    
    private(set) var isEditPinInfoInProgress: Bool = false
    
    enum EditPinPhotoError: Error, LocalizedError {
        case uploadPinPhotoError(UploadPinPhotoError)
        case updatePinPhotoUrlError(UpdatePinPhotoUrlError)
        case unknownError
        var errorDescription: String? {
            switch self {
            case .uploadPinPhotoError(let uploadPinPhotoError):
                uploadPinPhotoError.localizedDescription
            case .updatePinPhotoUrlError(let updatePinPhotoUrlError):
                updatePinPhotoUrlError.localizedDescription
            case .unknownError:
                "Unknown Error"
            }
        }
    }
    
    private(set) var editPinPhotoError: EditPinPhotoError? = nil
    
    private(set) var updatePinInfoError: UpdatePinInfoError? = nil
    
    var isEditPinPhotoAlertPresented: Bool = false
    
    var isEditPinInfoAlertPresented: Bool = false
    
    func editPinPhoto(for pinId: String) async {
        guard let data = newPinPhoto?.jpegData(compressionQuality: 1.0) else {
            return
        }
        isEditPinPhotoInProgress = true
        do {
            let newPinPhotoUrl = try await storageRepository.uploadPinPhoto(data: data, pinId: pinId)
            try await pinRepository.updatePinPhotoUrl(pinId: pinId, pinPhotoUrlString: newPinPhotoUrl)
            isEditPinPhotoInProgress = false
            editPinPhotoError = nil
            isEditPinPhotoAlertPresented = false
            await getPin(for: pinId)
        } catch {
            isEditPinPhotoInProgress = false
            if let uploadPinPhotoError = error as? UploadPinPhotoError {
                editPinPhotoError = .uploadPinPhotoError(uploadPinPhotoError)
            } else if let updatePinPhotoUrlError = error as? UpdatePinPhotoUrlError {
                editPinPhotoError = .updatePinPhotoUrlError(updatePinPhotoUrlError)
            } else {
                editPinPhotoError = .unknownError
            }
            isEditPinPhotoAlertPresented = true
        }
    }
    
    func editPinInfo(for pinId: String) async {
        isEditPinInfoInProgress = true
        do {
            try await pinRepository.updatePinInfo(pinId: pinId, pinName: trimmedNewPinName, pinDescription: trimmedNewPinDescription)
            await updateMemoriesPinInfo(pinId: pinId)
            isEditPinInfoInProgress = false
            updatePinInfoError = nil
            isEditPinInfoAlertPresented = false
            isEditPinSheetPresented = false
            await getPin(for: pinId)
        } catch {
            isEditPinInfoInProgress = false
            if let updatePinInfoError = error as? UpdatePinInfoError {
                self.updatePinInfoError = updatePinInfoError
            } else {
                updatePinInfoError = .updateFailed
            }
            isEditPinInfoAlertPresented = true
        }
    }
    
    private func updateMemoriesPinInfo(pinId: String) async {
        try? await memoryRepository.updateMemoriesPinInfo(pinId: pinId, pinName: trimmedNewPinName)
    }
    
    private(set) var isDeletePinInProgress: Bool = false
    
    private(set) var deletePinError: DeletePinError? = nil
    
    var isDeletePinAlertPresented: Bool = false
    
    var isDeletePinConfirmationPresented: Bool = false
    
    func deletePin(for pinId: String, onSuccess: () -> Void) async {
        isDeletePinInProgress = true
        do {
            try await pinRepository.deletePin(pinId: pinId)
            try await memoryRepository.deletePinMemories(pinId: pinId)
            isDeletePinInProgress = false
            deletePinError = nil
            isDeletePinAlertPresented = false
            onSuccess()
        } catch {
            isDeletePinInProgress = false
            if let deletePinError = error as? DeletePinError {
                self.deletePinError = deletePinError
            } else {
                deletePinError = .deleteFailed
            }
            isDeletePinAlertPresented = true
        }
    }
    
    private(set) var isDeleteMemoryInProgress: Bool = false
    
    private(set) var deleteMemoryError: DeleteMemoryError? = nil
    
    var isDeleteMemoryAlertPresented: Bool = false
    
    func deleteMemory(for memoryId: String) async {
        isDeleteMemoryInProgress = true
        do {
            try await memoryRepository.deleteMemory(memoryId: memoryId)
            try await storageRepository.deleteMemoryMedia(memoryId: memoryId)
            memories.removeAll {
                $0.id == memoryId
            }
            isDeleteMemoryInProgress = false
            deleteMemoryError = nil
            isDeleteMemoryAlertPresented = false
        } catch {
            isDeleteMemoryInProgress = false
            if let deleteMemoryError = error as? DeleteMemoryError {
                self.deleteMemoryError = deleteMemoryError
            } else {
                self.deleteMemoryError = .deleteFailed
            }
            isDeleteMemoryAlertPresented = true
        }
    }
}
