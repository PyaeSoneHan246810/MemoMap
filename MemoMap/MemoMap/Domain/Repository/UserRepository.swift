//
//  UserRepository.swift
//  MemoMap
//
//  Created by Dylan on 10/10/25.
//

import Foundation

protocol UserRepository {
    func followUser(userId: String, userToFollowId: String) async throws
    
    func unfollowUser(userId: String, userToUnfollowId: String) async throws
    
    func listenFollowingIds(userData: UserData?, completion: @escaping (Result<[String], Error>) -> Void )
}
