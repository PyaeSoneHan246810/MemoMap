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
    
    var currentSheetType: SheetType? = nil
    
    var isHeartGiven: Bool = false
    
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
            if let checkHeartError = error as? CheckHeartError {
                print(checkHeartError.localizedDescription)
            } else if let addMemoryHeartError = error as? AddMemoryHeartError {
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
        await increaseHeartsCount(memoryId: memoryId)
    }
    
    private func removeHart(memoryId: String, userId: String) async throws {
        try await memoryRepository.removeMemeoryHeart(memoryId: memoryId, userId: userId)
        await decreaseHeartsCount(memoryId: memoryId)
    }
    
    func increaseHeartsCount(memoryId: String) async {
        do {
            try await memoryRepository.increaseMemoryHeartsCount(memoryId: memoryId)
        } catch {
            if let updateMemoryHeartsCountError = error as? UpdateMemoryHeartsCountError {
                print(updateMemoryHeartsCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func decreaseHeartsCount(memoryId: String) async {
        do {
            try await memoryRepository.decreaseMemoryHeartsCount(memoryId: memoryId)
        } catch {
            if let updateMemoryHeartsCountError = error as? UpdateMemoryHeartsCountError {
                print(updateMemoryHeartsCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
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
