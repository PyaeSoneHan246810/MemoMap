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
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    var isPostMemorySheetPresented: Bool = false
    
    var userProfileScreenModel: UserProfileScreenModel? = nil
    
    private(set) var followingIdsDataState: DataState<[String]> = .initial {
        didSet {
            if case .success(let followingIds) = followingIdsDataState {
                Task {
                    await loadFollowingsPublicMemories(followingIds: followingIds)
                }
            }
        }
    }
    
    private(set) var memoryPostsDataState: DataState<[MemoryPost]> = .initial
    
    private var followingIds: [String] {
        if case .success(let data) = followingIdsDataState {
            return data
        } else {
            return []
        }
    }
    
    var memoryPosts: [MemoryPost] {
        if case .success(let data) = memoryPostsDataState {
            return data
        } else {
            return []
        }
    }
    
    func listenFollowingIds() {
        followingIdsDataState = .loading
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowingIds(userData: userData) { [weak self] result in
            switch result {
            case .success(let followingIds):
                self?.followingIdsDataState = .success(followingIds)
            case .failure(let error):
                if let listenFollowingIdsError = error as? ListenFollowingIdsError {
                    let errorDescription = listenFollowingIdsError.localizedDescription
                    print(errorDescription)
                    self?.followingIdsDataState = .failure(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                    self?.followingIdsDataState = .failure(errorDescription)
                }
            }
        }
    }
    
    private func loadFollowingsPublicMemories(followingIds: [String]) async {
        memoryPostsDataState = .loading
        let chunks = followingIds.chunked(into: 30)
        var allMemoryPosts: [MemoryPost] = []
        do {
            for chunk in chunks {
                let chunkedMemories = try await memoryRepository.loadFollowingsPublicMemories(followingIds: chunk)
                let chunkedMemoryPosts = chunkedMemories.map { memory in
                    MemoryPost(memory: memory, userProfile: nil)
                }
                allMemoryPosts.append(contentsOf: chunkedMemoryPosts)
            }
            memoryPostsDataState = .success(allMemoryPosts)
        } catch {
            if let loadFollowingsPublicMemoriesError = error as? LoadFollowingsPublicMemoriesError {
                let errorDescription = loadFollowingsPublicMemoriesError.localizedDescription
                print(errorDescription)
                memoryPostsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                memoryPostsDataState = .failure(errorDescription)
            }
        }
    }
}
