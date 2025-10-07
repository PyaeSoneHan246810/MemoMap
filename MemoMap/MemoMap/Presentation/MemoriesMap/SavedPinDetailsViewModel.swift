//
//  SavedPinDetailsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 7/10/25.
//

import Foundation
import Observation
import Factory


@Observable
final class SavedPinDetailsViewModel {
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var memoriesDataState: DataState<[MemoryData]> = .initial
    
    var memories: [MemoryData] {
        if case .success(let data) = memoriesDataState {
            return data
        } else {
            return []
        }
    }
    
    func listenMemories(for pinId: String) {
        self.memoriesDataState = .loading
        memoryRepository.listenPinMemories(pinId: pinId) { [weak self] result in
            switch result {
            case .success(let memories):
                self?.memoriesDataState = .success(memories)
            case .failure(let error):
                if let listenPinMemoriesError = error as? ListenPinMemoriesError {
                    print(listenPinMemoriesError.localizedDescription)
                    self?.memoriesDataState = .failure(listenPinMemoriesError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                    self?.memoriesDataState = .failure(error.localizedDescription)
                }
            }
        }
    }
}
