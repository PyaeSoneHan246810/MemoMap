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
    
    var isAddPinSheetViewPresented: Bool = false
    
    private(set) var pins: [PinData] = []
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
    }
    
    var locationPhotoImage: UIImage? = nil
    
    var locationName: String = ""
    
    var locationDescription: String = ""
    
    var locationPlace: Place? = nil
    
    var filteredPins: [PinData] {
        if trimmedSearchText.isEmpty {
            pins
        } else {
            pins.filter { pin in
                pin.name.contains(trimmedSearchText)
            }
        }
    }
    
    var trimmedLocationName: String {
        locationName.trimmed()
    }
    
    var trimmedLocationDescription: String {
        locationDescription.trimmed()
    }
    
    func getPins() async {
        let userData = authenticationRepository.getUserData()
        do {
            let pins = try await pinRepository.getPins(userData: userData)
            self.pins = pins
        } catch {
            if let getPinsError = error as? GetPinsError {
                print(getPinsError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveNewPin() async {
        guard let place = locationPlace else {
            return
        }
        let pinData = PinData(
            id: "",
            name: trimmedLocationName,
            description: trimmedLocationDescription.isEmpty ? nil : trimmedLocationDescription,
            photoUrl: nil,
            latitude: place.latitude,
            longitude: place.longitude,
            createdAt: .now
        )
        let userData = authenticationRepository.getUserData()
        do {
            let savedPinId = try await pinRepository.savePin(pinData: pinData, userData: userData)
            if let pinPhotoUrlString = await uploadPinPhoto(pinId: savedPinId) {
                await updatePinPhotoUrl(pinId: savedPinId, pinPhotoUrlString: pinPhotoUrlString)
            }
            isAddPinSheetViewPresented = false
            await getPins()
        } catch {
            if let savePinError = error as? SavePinError {
                print(savePinError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadPinPhoto(pinId: String) async -> String? {
        guard let locationPhotoImage, let data = locationPhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let pinPhotoUrlString = try await storageRepository.uploadPinPhoto(data: data, pinId: pinId)
            return pinPhotoUrlString
        } catch {
            if let uploadPinPhotoError = error as? UploadPinPhotoError {
                print(uploadPinPhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func updatePinPhotoUrl(pinId: String, pinPhotoUrlString: String) async {
        do {
            try await pinRepository.updatePinPhotoUrl(pinId: pinId, pinPhotoUrlString: pinPhotoUrlString)
        } catch {
            if let updatePinPhotoUrlError = error as? UpdatePinPhotoUrlError {
                print(updatePinPhotoUrlError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
