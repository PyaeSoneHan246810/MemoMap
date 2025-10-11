//
//  UserRepository.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

protocol UserRepository {
    func followUser(userData: UserData?, userToFollowId: String) async throws
    
    func unfollowUser(userData: UserData?, userToUnfollowId: String) async throws
    
    func listenFollowingIds(userData: UserData?, completion: @escaping (Result<[String], Error>) -> Void )
    
    func listenFollowerIds(userData: UserData?, completion: @escaping (Result<[String], Error>) -> Void )
    
    func searchUsers(searchText: String) async throws -> [UserProfileData]
}
