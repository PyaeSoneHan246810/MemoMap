//
//  ChooseLocationViewModel.swift
//  MemoMap
//
//  Created by Dylan on 21/10/25.
//

import Foundation
import Observation
import Factory

@Observable
class ChooseLocationViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.pinRepository) private var pinRepository: PinRepository
    
    private(set) var pins: [PinData] = []
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
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
}
