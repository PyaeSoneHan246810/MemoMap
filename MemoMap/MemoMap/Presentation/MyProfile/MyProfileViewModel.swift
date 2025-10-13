//
//  ProfileViewModel.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class MyProfileViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var memoriesDataState: DataState<[MemoryData]> = .initial

    var memories: [MemoryData] {
        if case .success(let data) = memoriesDataState {
            return data
        } else {
            return []
        }
    }
    
    func listenUserPublicMemories() {
        self.memoriesDataState = .loading
        let userData = authenticationRepository.getUserData()
        memoryRepository.listenUserPublicMemories(userData: userData) { [weak self] result in
            switch result {
            case .success(let memories):
                self?.memoriesDataState = .success(memories)
            case .failure(let error):
                if let listenUserPublicMemoriesError = error as? ListenUserPublicMemoriesError {
                    let errorDescription = listenUserPublicMemoriesError.localizedDescription
                    print(errorDescription)
                    self?.memoriesDataState = .failure(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                    self?.memoriesDataState = .failure(errorDescription)
                }
            }
        }
    }
}
