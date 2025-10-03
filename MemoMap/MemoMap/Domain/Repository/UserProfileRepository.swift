//
//  UserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

protocol UserProfileRepository {
    func checkUsernameAvailability(username: String) async throws
    
    func saveUserProfile(userProfile: UserProfileModel) async throws
    
    func deleteUserProfile(user: UserModel?) async throws
}
