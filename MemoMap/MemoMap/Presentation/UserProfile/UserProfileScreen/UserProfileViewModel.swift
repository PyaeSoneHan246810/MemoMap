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
    
    private(set) var memoriesDataState: DataState<[MemoryData]> = .initial
    
    var userType: UserType? = nil
    
    var followingsCount: Int = 0
    
    var followersCount: Int = 0
    
    var totalHeartsCount: Int = 0
    
    var userProfile: UserProfileData? {
        if case .success(let data) = userProfileDataState {
            data
        } else {
            nil
        }
    }
    
    var memories: [MemoryData] {
        if case .success(let data) = memoriesDataState {
            data
        } else {
            []
        }
    }
    
    func getUserProfile(userId: String) async {
        userProfileDataState = .loading
        do {
            let userProfile = try await userProfileRepository.getUserProfile(userId: userId)
            userProfileDataState = .success(userProfile)
        } catch {
            if let getUserProfileError = error as? GetUserProfileError {
                let errorDescription = getUserProfileError.localizedDescription
                print(errorDescription)
                userProfileDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                userProfileDataState = .failure(errorDescription)
            }
        }
    }
    
    func listenFollowingsIds(userId: String) {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowingIds(userData: userData) { [weak self] result in
            switch result {
            case .success(let followingIds):
                self?.userType = followingIds.contains(userId) ? .following : .notFollowing
            case .failure(let error):
                if let listenFollowingIdsError = error as? ListenFollowingIdsError {
                    print(listenFollowingIdsError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
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
    
    func getTotalHeartsCount(userId: String) async {
        do {
            let totalHeartsCount = try await memoryRepository.getTotoalHeartsCount(userId: userId)
            self.totalHeartsCount = totalHeartsCount
        } catch {
            if let getTotalHeartsCountError = error as? GetTotalHeartsCountError {
                print(getTotalHeartsCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func getFollowingsCount(userId: String) async {
        do {
            let followingsCount = try await userRepository.getFollowingsCount(userId: userId)
            self.followingsCount = followingsCount
        } catch {
            if let getCountError = error as? GetCountError {
                print(getCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func getFollowersCount(userId: String) async {
        do {
            let followersCount = try await userRepository.getFollowersCount(userId: userId)
            self.followersCount = followersCount
        } catch {
            if let getCountError = error as? GetCountError {
                print(getCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
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
