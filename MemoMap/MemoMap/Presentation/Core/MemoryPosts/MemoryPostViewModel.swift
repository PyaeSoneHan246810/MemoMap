//
//  MemoryPostViewModel.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class MemoryPostViewModel {
    
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    var currentSheetType: SheetType? = nil
    
    var userProfile: UserProfileData? = nil
    
    private(set) var isHeartGiven: Bool = false
    
    private(set) var heartsCount: Int = 0
    
    private(set) var commentsCount: Int = 0
    
    var currentUserId: String? {
        authenticationRepository.getUserData()?.uid
    }
    
    func checkIsHeartGiven(memoryId: String) async {
        guard let userId = authenticationRepository.getUserData()?.uid else { return }
        do {
            self.isHeartGiven = try await memoryRepository.checkIsHeartGiven(memoryId: memoryId, userId: userId)
        } catch {
            if let checkHeartError = error as? CheckHeartError {
                print(checkHeartError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func toggleHeart(memoryId: String) async {
        guard let userId = authenticationRepository.getUserData()?.uid else { return }
        do {
            if isHeartGiven {
                try await removeHart(memoryId: memoryId, userId: userId)
            } else {
                try await addHeart(memoryId: memoryId, userId: userId)
            }
            await checkIsHeartGiven(memoryId: memoryId)
        } catch {
            if let addMemoryHeartError = error as? AddMemoryHeartError {
                print(addMemoryHeartError.localizedDescription)
            } else if let removeMemoryHeartError = error as? RemoveMemoryHeartError {
                print(removeMemoryHeartError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func addHeart(memoryId: String, userId: String) async throws {
        let heart = HeartData(id: userId, createdAt: .now)
        try await memoryRepository.addMemoryHeart(memoryId: memoryId, heartData: heart)
    }
    
    private func removeHart(memoryId: String, userId: String) async throws {
        try await memoryRepository.removeMemeoryHeart(memoryId: memoryId, userId: userId)
    }
    
    func listenHeartsCount(memoryId: String) {
        memoryRepository.listenHeartsCount(memoryId: memoryId) { [weak self] result in
            switch result {
            case .success(let heartsCount):
                self?.heartsCount = heartsCount
            case .failure(let error):
                if let listenCountError = error as? ListenCountError {
                    let errorDescription = listenCountError.localizedDescription
                    print(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
    
    func listenCommentsCount(memoryId: String) {
        memoryRepository.listenCommentsCount(memoryId: memoryId) { [weak self] result in
            switch result {
            case .success(let commentsCount):
                self?.commentsCount = commentsCount
            case .failure(let error):
                if let listenCountError = error as? ListenCountError {
                    let errorDescription = listenCountError.localizedDescription
                    print(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                }
            }
        }
    }
    
    func getUserProfile(userId: String) async {
        let userProfile = try? await userProfileRepository.getUserProfile(userId: userId)
        self.userProfile = userProfile
    }
}

extension MemoryPostViewModel {
    enum SheetType: String, Identifiable {
        case viewOnMap = "View on map"
        case hearts = "Hearts"
        case comments = "Comments"
        var id: String {
            self.rawValue
        }
    }
}
