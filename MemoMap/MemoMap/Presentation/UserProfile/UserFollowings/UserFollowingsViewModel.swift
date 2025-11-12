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
            let sortedFollowingUsers = followingUsers.sorted { lhs, rhs in
                lhs.displayname.lowercased() < rhs.displayname.lowercased()
            }
            followingUsersDataState = .success(sortedFollowingUsers)
        } catch {
            if let getFollowingsError = error as? GetFollowingsError {
                let errorDescription = getFollowingsError.localizedDescription
                followingUsersDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                followingUsersDataState = .failure(errorDescription)
            }
        }
    }
}
