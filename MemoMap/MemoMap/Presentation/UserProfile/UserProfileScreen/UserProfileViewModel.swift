//
//  UserProfileViewModel.swift
//  MemoMap
//
//  Created by Dylan on 14/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class UserProfileViewModel {
    
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    private(set) var userProfileDataState: DataState<UserProfileData> = .initial
    
    var userProfile: UserProfileData? {
        if case .success(let data) = userProfileDataState {
            data
        } else {
            nil
        }
    }
    
    private(set) var memoriesDataState: DataState<[MemoryData]> = .initial
    
    var memories: [MemoryData] {
        if case .success(let data) = memoriesDataState {
            data
        } else {
            []
        }
    }
    
    var userType: UserType? = nil
    
    var followingsCount: Int = 0
    
    var followersCount: Int = 0
    
    var totalHeartsCount: Int = 0
    
    func getUserProfile(userId: String) async {
        userProfileDataState = .loading
        do {
            let userProfile = try await userProfileRepository.getUserProfile(userId: userId)
            userProfileDataState = .success(userProfile)
        } catch {
            if let getUserProfileError = error as? GetUserProfileError {
                let errorDescription = getUserProfileError.localizedDescription
                userProfileDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                userProfileDataState = .failure(errorDescription)
            }
        }
    }
    
    func getUserPublicMemories(userId: String) async {
        memoriesDataState = .loading
        do {
            let memories = try await memoryRepository.getUserPublicMemories(userId: userId)
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
    
    func getTotalHeartsCount(userId: String) async {
        let totalHeartsCount = try? await memoryRepository.getTotoalHeartsCount(userId: userId)
        self.totalHeartsCount = totalHeartsCount ?? 0
    }
    
    func getFollowingsCount(userId: String) async {
        let followingsCount = try? await userRepository.getFollowingsCount(userId: userId)
        self.followingsCount = followingsCount ?? 0
    }
    
    func getFollowersCount(userId: String) async {
        let followersCount = try? await userRepository.getFollowersCount(userId: userId)
        self.followersCount = followersCount ?? 0
    }
    
    func listenFollowingsIds(userId: String) {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowingIds(userData: userData) { [weak self] result in
            switch result {
            case .success(let followingIds):
                self?.userType = followingIds.contains(userId) ? .following : .notFollowing
            case .failure(let error):
                self?.userType = nil
            }
        }
    }
    
    func followUser(userId: String) async {
        let userData = authenticationRepository.getUserData()
        do {
            try await userRepository.followUser(userData: userData, userToFollowId: userId)
        } catch {
            if let followUserError = error as? FollowUserError {
                print(followUserError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func unfollowUser(userId: String) async {
        let userData = authenticationRepository.getUserData()
        do {
            try await userRepository.unfollowUser(userData: userData, userToUnfollowId: userId)
        } catch {
            if let unfollowUserError = error as? UnfollowUserError {
                print(unfollowUserError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
 
}
