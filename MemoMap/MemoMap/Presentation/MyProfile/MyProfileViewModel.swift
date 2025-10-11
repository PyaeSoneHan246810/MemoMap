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
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var userProfileDataState: DataState<UserProfileData> = .initial {
        didSet {
            if case .success = userProfileDataState {
                updateMemoryPostsWithLatestUserProfile()
            }
        }
    }
    
    private(set) var memoryPostsDataState: DataState<[MemoryPost]> = .initial
    
    var userProfile: UserProfileData? {
        if case .success(let data) = userProfileDataState {
            return data
        } else {
            return nil
        }
    }
    
    var memoryPosts: [MemoryPost] {
        if case .success(let data) = memoryPostsDataState {
            return data
        } else {
            return []
        }
    }
    
    func listenUserProfile() {
        self.userProfileDataState = .loading
        let userData = authenticationRepository.getUserData()
        userProfileRepository.listenUserProfile(userData: userData) { [weak self] result in
            switch result {
            case .success(let userProfileData):
                self?.userProfileDataState = .success(userProfileData)
            case .failure(let error):
                if let listenUserProfileError = error as? ListenUserProfileError {
                    let errorDescription = listenUserProfileError.localizedDescription
                    print(errorDescription)
                    self?.userProfileDataState = .failure(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                    self?.userProfileDataState = .failure(errorDescription)
                }
            }
        }
    }
    
    func listenUserPublicMemories() {
        self.memoryPostsDataState = .loading
        let userData = authenticationRepository.getUserData()
        memoryRepository.listenUserPublicMemories(userData: userData) { [weak self] result in
            switch result {
            case .success(let memories):
                var memoryPosts: [MemoryPost] = []
                for memory in memories {
                    let userProfile = self?.userProfile
                    let memoryPost = MemoryPost(
                        memory: memory,
                        userProfile: userProfile
                    )
                    memoryPosts.append(memoryPost)
                }
                self?.memoryPostsDataState = .success(memoryPosts)
            case .failure(let error):
                if let listenUserPublicMemoriesError = error as? ListenUserPublicMemoriesError {
                    let errorDescription = listenUserPublicMemoriesError.localizedDescription
                    print(errorDescription)
                    self?.memoryPostsDataState = .failure(errorDescription)
                } else {
                    let errorDescription = error.localizedDescription
                    print(errorDescription)
                    self?.memoryPostsDataState = .failure(errorDescription)
                }
            }
        }
    }
    
    private func updateMemoryPostsWithLatestUserProfile() {
        guard case .success(let memoryPosts) = memoryPostsDataState else {
            return
        }
        guard let updatedProfile = userProfile else {
            return
        }
        let updatedPosts = memoryPosts.map { memoryPost in
            MemoryPost(
                memory: memoryPost.memory,
                userProfile: updatedProfile
            )
        }
        memoryPostsDataState = .success(updatedPosts)
    }
}
