//
//  UserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

protocol UserProfileRepository {
    
    func saveUserProfile(userProfileData: UserProfileData) async throws
    
    func checkUsernameAvailability(username: String) async throws
    
    func deleteUserProfile(userData: UserData?) async throws
    
    func listenUserProfile(userData: UserData?, completion: @escaping (Result<UserProfileData, Error>) -> Void)
    
    func getUserProfile(userId: String) async throws -> UserProfileData
    
    func updateUserProfileInfo(userid: String, updateUserProfileData: UpdateUserProfileData) async throws
    
}
