//
//  FeedViewModel.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class FeedViewModel {
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    var isPostMemorySheetPresented: Bool = false

    private(set) var memoriesDataState: DataState<[MemoryData]> = .initial
    
    var memories: [MemoryData] {
        if case .success(let data) = memoriesDataState {
            return data
        } else {
            return []
        }
    }
    
    func getFollowingsPublicMemories(followingIds: [String]) async {
        memoriesDataState = .loading
        let chunks = followingIds.chunked(into: 30)
        var allMemories: [MemoryData] = []
        do {
            for chunk in chunks {
                let chunkedMemories = try await memoryRepository.getFollowingsPublicMemories(followingIds: chunk)
                allMemories.append(contentsOf: chunkedMemories)
            }
            memoriesDataState = .success(allMemories)
        } catch {
            if let getFollowingsPublicMemoriesError = error as? GetFollowingsPublicMemoriesError {
                let errorDescription = getFollowingsPublicMemoriesError.localizedDescription
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
