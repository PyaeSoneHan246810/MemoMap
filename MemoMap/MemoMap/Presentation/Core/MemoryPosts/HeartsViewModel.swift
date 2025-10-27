//
//  HeartsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class HeartsViewModel {
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    private(set) var userHeartsDataState: DataState<[UserHeart]> = .initial
    
    func getUserHearts(memoryId: String) async {
        userHeartsDataState = .loading
        do {
            let hearts = try await memoryRepository.getMemoryHearts(memoryId: memoryId)
            var userHearts: [UserHeart] = []
            for heart in hearts {
                let userProfile = try? await userProfileRepository.getUserProfile(userId: heart.id)
                let userHeart = UserHeart(heart: heart, userProfile: userProfile)
                userHearts.append(userHeart)
            }
            let sortedUserHearts = userHearts.sorted { lhs, rhs in
                lhs.heart.createdAt > rhs.heart.createdAt
            }
            userHeartsDataState = .success(sortedUserHearts)
        } catch {
            if let getMemoryHeartsError = error as? GetMemoryHeartsError {
                let errorDescription = getMemoryHeartsError.localizedDescription
                userHeartsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                userHeartsDataState = .failure(errorDescription)
            }
        }
    }
}
