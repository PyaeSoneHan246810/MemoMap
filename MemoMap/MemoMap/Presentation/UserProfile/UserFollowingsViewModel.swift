//
//  UserFollowingsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class UserFollowingsViewModel {
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    private(set) var followingUsersDataState: DataState<[UserProfileData]> = .initial
    
    var followingUsers: [UserProfileData] {
        if case .success(let data) = followingUsersDataState {
            data
        } else {
            []
        }
    }
    
    func getFollowingUsers(of userId: String) async {
        followingUsersDataState = .loading
        do {
            var followingUsers: [UserProfileData] = []
            let followings = try await userRepository.getFollowings(userId: userId)
            for following in followings {
                if let followingUser = try? await userProfileRepository.getUserProfile(userId: following.id) {
                    followingUsers.append(followingUser)
                }
            }
            followingUsersDataState = .success(followingUsers)
        } catch {
            if let getFollowingsError = error as? GetFollowingsError {
                let errorDescription = getFollowingsError.localizedDescription
                print(errorDescription)
                followingUsersDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                followingUsersDataState = .failure(errorDescription)
            }
        }
    }
}
