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
    
    private(set) var pinsDataState: DataState<[PinData]> = .initial
    
    var viewport: Viewport = .followPuck(zoom: 12.0, bearing: .constant(0.0), pitch: 0.0)
    
    var clusterOptions: ClusterOptions = .init()
    
    var placeTapped: Place? = nil
    
    var pins: [PinData] {
        if case .success(let data) = pinsDataState {
            return data
        } else {
            return []
        }
    }
    
    func listenPins() {
        self.pinsDataState = .loading
        let userData = authenticationRepository.getUserData()
        pinRepository.listenPins(userData: userData) { [weak self]  result in
            switch result {
            case .success(let pins):
                self?.pinsDataState = .success(pins)
            case .failure(let error):
                if let listenPinsError = error as? ListenPinsError {
                    print(listenPinsError.localizedDescription)
                    self?.pinsDataState = .failure(listenPinsError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                    self?.pinsDataState = .failure(error.localizedDescription)
                }
            }
        }
    }
}
