//
//  UserFollowersViewModel.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class UserFollowersViewModel {
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    private(set) var followerUsersDataState: DataState<[UserProfileData]> = .initial
    
    var followerUsers: [UserProfileData] {
        if case .success(let data) = followerUsersDataState {
            data
        } else {
            []
        }
    }
    
    func getFollowerUsers(of userId: String) async {
        followerUsersDataState = .loading
        do {
            var followerUsers: [UserProfileData] = []
            let followers = try await userRepository.getFollowers(userId: userId)
            for follower in followers {
                if let followerUser = try? await userProfileRepository.getUserProfile(userId: follower.id) {
                    followerUsers.append(followerUser)
                }
            }
            followerUsersDataState = .success(followerUsers)
        } catch {
            if let getFollowersError = error as? GetFollowersError {
                let errorDescription = getFollowersError.localizedDescription
                print(errorDescription)
                followerUsersDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                followerUsersDataState = .failure(errorDescription)
            }
        }
    }
}
