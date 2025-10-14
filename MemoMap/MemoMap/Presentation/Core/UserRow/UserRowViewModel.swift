//
//  UserRowViewModel.swift
//  MemoMap
//
//  Created by Dylan on 11/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class UserRowViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    var userType: UserType? = nil
    
    var currentUserId: String? {
        authenticationRepository.getUserData()?.uid
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
}
