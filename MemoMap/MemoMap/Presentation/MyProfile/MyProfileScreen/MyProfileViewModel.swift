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
    
    private(set) var totalHeartsCount: Int = 0
    
    var userProfileToEdit: UserProfileData? = nil
    
    func getUserPublicMemories() async {
        memoriesDataState = .loading
        let userData = authenticationRepository.getUserData()
        do {
            let memories = try await memoryRepository.getUserPublicMemories(userData: userData)
            memoriesDataState = .success(memories)
        } catch {
            if let getUserPublicMemoriesError = error as? GetUserPublicMemoriesError {
                let errorDescription = getUserPublicMemoriesError.localizedDescription
                memoriesDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                memoriesDataState = .failure(errorDescription)
            }
        }
    }
    
    func getTotalHeartsCount() async {
        let userData = authenticationRepository.getUserData()
        let totalHeartsCount = try? await memoryRepository.getTotalHeartsCount(userData: userData)
        self.totalHeartsCount = totalHeartsCount ?? 0
    }
}
