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
    
    func searchUsersByUsernameOrDisplayName(name: String) async throws -> [UserProfileData]
    
    func listenFollowingsCount(userData: UserData?, completion: @escaping (Result<Int, Error>) -> Void)
    
    func listenFollowersCount(userData: UserData?, completion: @escaping (Result<Int, Error>) -> Void)
    
    func listenFollowings(userData: UserData?, completion: @escaping (Result<[FollowingData], Error>) -> Void)
    
    func listenFollowers(userData: UserData?, completion: @escaping (Result<[FollowerData], Error>) -> Void)

    func getFollowingsCount(userId: String) async throws -> Int
    
    func getFollowersCount(userId: String) async throws -> Int
    
    func getFollowings(userId: String) async throws -> [FollowingData]
    
    func getFollowers(userId: String) async throws -> [FollowerData]
}
