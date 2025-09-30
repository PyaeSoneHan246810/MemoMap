//
//  AuthenticationRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

protocol AuthenticationRepository {
    func getAuthenticatedUser() -> UserModel?
    
    func createUser(email: String, password: String) async throws -> UserModel
    
    func deleteUser() async throws
    
    func signOutUser() throws
}
