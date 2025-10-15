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
    
    var userHearts: [UserHeart] {
        if case .success(let data) = userHeartsDataState {
            return data
        } else {
            return []
        }
    }
    
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
            print(userHearts)
            userHeartsDataState = .success(userHearts)
        } catch {
            if let getMemoryHeartsError = error as? GetMemoryHeartsError {
                let errorDescription = getMemoryHeartsError.localizedDescription
                print(errorDescription)
                userHeartsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                userHeartsDataState = .failure(errorDescription)
            }
        }
    }
}
