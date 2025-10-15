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
    
    func getMemories(for pinId: String) async {
        memoriesDataState = .loading
        do {
            let memories = try await memoryRepository.getPinMemories(pinId: pinId)
            memoriesDataState = .success(memories)
        } catch {
            if let getPinMemoriesError = error as? GetPinMemoriesError {
                let errorDescription = getPinMemoriesError.localizedDescription
                print(errorDescription)
                memoriesDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                memoriesDataState = .failure(errorDescription)
            }
        }
    }
}
