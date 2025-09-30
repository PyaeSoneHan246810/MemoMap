//
//  UserProfileRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

protocol UserProfileRepository {
    func saveUserProfile(userProfile: UserProfileModel) async throws
}
