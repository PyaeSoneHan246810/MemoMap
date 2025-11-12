//
//  MemoriesViewModel.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import Foundation
import Observation
import Factory
import MapboxMaps

@Observable
final class MemoriesViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.pinRepository) private var pinRepository: PinRepository
    
    var viewport: Viewport = .followPuck(zoom: 12.0, bearing: .constant(0.0), pitch: 0.0)
    
    var clusterOptions: ClusterOptions = .init()
    
    var placeTapped: Place? = nil
    
    var pinTapped: PinData? = nil
    
    private(set) var pins: [PinData] = []
    
    func listenPins() {
        let userData = authenticationRepository.getUserData()
        pinRepository.listenPins(userData: userData) { [weak self]  result in
            switch result {
            case .success(let pins):
                self?.pins = pins
            case .failure(let error):
                if let listenPinsError = error as? ListenPinsError {
                    let errorDescription = listenPinsError.localizedDescription
                    print(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
}
