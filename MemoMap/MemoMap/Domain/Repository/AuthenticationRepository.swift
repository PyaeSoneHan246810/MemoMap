//
//  AuthenticationRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

protocol AuthenticationRepository {
    func getAuthenticatedUser() -> UserModel?
    
    func reloadAuthenticatedUser() async throws
    
    func createUser(email: String, password: String) async throws -> UserModel
    
    func signInUser(email: String, password: String) async throws
    
    func deleteUser() async throws
    
    func signOutUser() throws
    
    func sendEmailVerification() async throws
    
    func sendPasswordReset(email: String) async throws
}
