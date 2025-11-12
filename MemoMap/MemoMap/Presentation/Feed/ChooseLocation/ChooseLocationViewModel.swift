//
//  ChooseLocationViewModel.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import SwiftUI
import PhotosUI
import Observation
import Factory

@Observable
class ChooseLocationViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.pinRepository) private var pinRepository: PinRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    var userData: UserData? {
        authenticationRepository.getUserData()
    }
    
    var isAddPinSheetViewPresented: Bool = false
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
    }
    
    var locationPhotoImage: UIImage? = nil
    
    var locationName: String = ""
    
    var trimmedLocationName: String {
        locationName.trimmed()
    }
    
    var locationDescription: String = ""
    
    private var trimmedLocationDescription: String {
        locationDescription.trimmed()
    }
    
    var locationPlace: Place? = nil
    
    private(set) var pinsDataState: DataState<[PinData]> = .initial
    
    
    private var pins: [PinData] {
        if case .success(let data) = pinsDataState {
            data
        } else {
            []
        }
    }
    
    var filteredPins: [PinData] {
        if trimmedSearchText.isEmpty {
            pins
        } else {
            pins.filter { pin in
                pin.name.contains(trimmedSearchText)
            }
        }
    }
    
    func getPins() async {
        pinsDataState = .loading
        let userData = authenticationRepository.getUserData()
        do {
            let pins = try await pinRepository.getPins(userData: userData)
            pinsDataState = .success(pins)
        } catch {
            if let getPinsError = error as? GetPinsError {
                let errorDescription = getPinsError.localizedDescription
                pinsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                pinsDataState = .failure(errorDescription)
            }
        }
    }
    
    private(set) var isSavePinInProgress: Bool = false
    
    private(set) var savePinError: SavePinError? = nil
    
    var isSavePinAlertPresented: Bool = false
    
    func saveNewPin() async {
        guard let place = locationPlace else {
            return
        }
        isSavePinInProgress = true
        let pinData = PinData(
            id: "",
            name: trimmedLocationName,
            description: trimmedLocationDescription.isEmpty ? nil : trimmedLocationDescription,
            photoUrl: nil,
            latitude: place.latitude,
            longitude: place.longitude,
            createdAt: .now
        )
        do {
            let savedPinId = try await pinRepository.savePin(pinData: pinData, userData: userData)
            if let pinPhotoUrlString = await uploadPinPhoto(pinId: savedPinId) {
                await updatePinPhotoUrl(pinId: savedPinId, pinPhotoUrlString: pinPhotoUrlString)
            }
            isSavePinInProgress = false
            savePinError = nil
            isSavePinAlertPresented = false
            isAddPinSheetViewPresented = false
            await getPins()
        } catch {
            isSavePinInProgress = false
            if let savePinError = error as? SavePinError {
                self.savePinError = savePinError
            } else {
                savePinError = .saveFailed
            }
            isSavePinAlertPresented = true
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
}
