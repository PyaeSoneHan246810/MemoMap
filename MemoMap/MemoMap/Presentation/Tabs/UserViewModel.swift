//
//  UserViewModel.swift
//  MemoMap
//
//  Created by Dylan on 12/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class UserViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    private(set) var userProfileDataState: DataState<UserProfileData> = .initial
    
    private(set) var followingIdsDataState: DataState<[String]> = .initial
    
    private(set) var followerUsers: [UserProfileData] = []
    
    private(set) var followingUsers: [UserProfileData] = []
    
    private(set) var mutualUsers: [UserProfileData] = []
    
    private(set) var followersCount: Int = 0
    
    private(set) var followingsCount: Int = 0
    
    var mutualsCount: Int {
        mutualUsers.count
    }
    
    var userProfile: UserProfileData? {
        if case .success(let data) = userProfileDataState {
            return data
        } else {
            return nil
        }
    }
    
    var followingIds: [String] {
        if case .success(let data) = followingIdsDataState {
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
    
    func listenFollowers() {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowers(userData: userData) { [weak self] result in
            switch result {
            case .success(let followers):
                Task {
                    var followerUsers: [UserProfileData] = []
                    for follower in followers {
                        if let userProfile = try? await self?.userProfileRepository.getUserProfile(userId: follower.id) {
                            followerUsers.append(userProfile)
                        }
                    }
                    await MainActor.run {
                        self?.followerUsers = followerUsers
                        self?.getMutualUsers()
                    }
                }
            case .failure(let error):
                if let listenFollowersError = error as? ListenFollowersError {
                    print(listenFollowersError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func listenFollowings() {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowings(userData: userData) { [weak self] result in
            switch result {
            case .success(let followings):
                Task {
                    var followingUsers: [UserProfileData] = []
                    for following in followings {
                        if let userProfile = try? await self?.userProfileRepository.getUserProfile(userId: following.id) {
                            followingUsers.append(userProfile)
                        }
                    }
                    await MainActor.run {
                        self?.followingUsers = followingUsers
                        self?.getMutualUsers()
                    }
                }
            case .failure(let error):
                if let listenFollowingsError = error as? ListenFollowingsError {
                    print(listenFollowingsError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getMutualUsers() {
        let followerIds = Set(followerUsers.map { $0.id })
        let followingIds = Set(followingUsers.map { $0.id })
        let mutualIds = followerIds.intersection(followingIds)
        self.mutualUsers = followerUsers.filter { mutualIds.contains($0.id) }
    }
    
    func listenFollowersCount() {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowersCount(userData: userData) { [weak self] result in
            switch result {
            case .success(let count):
                self?.followersCount = count
            case .failure(let error):
                if let listenCountError = error as? ListenCountError {
                    print(listenCountError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func listenFollowingsCount() {
        let userData = authenticationRepository.getUserData()
        userRepository.listenFollowingsCount(userData: userData) { [weak self] result in
            switch result {
            case .success(let count):
                self?.followingsCount = count
            case .failure(let error):
                if let listenCountError = error as? ListenCountError {
                    print(listenCountError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
