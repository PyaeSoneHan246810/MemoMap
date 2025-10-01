//
//  FirebaseAuthenticationRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthenticationRepository: AuthenticationRepository {
    func getAuthenticatedUser() -> UserModel? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let authenticatedUser = getUserModel(from: currentUser)
        return authenticatedUser
    }
    
    func createUser(email: String, password: String) async throws -> UserModel {
        do {
            let authDataResult = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            let user = getUserModel(from: authDataResult.user)
            return user
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .invalidEmail:
                    throw CreateUserError.invalidEmail
                case .weakPassword:
                    throw CreateUserError.weakPassword
                case .emailAlreadyInUse:
                    throw CreateUserError.emailAlreadyInUse
                case .networkError:
                    throw CreateUserError.networkError
                default:
                    throw CreateUserError.unknownError
                }
            } else {
                throw CreateUserError.unknownError
            }
        }
    }
    
    private func getUserModel(from user: User) -> UserModel {
        UserModel(uid: user.uid, email: user.email)
    }
    
    func signInUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .invalidEmail:
                    throw SignInUserError.invalidEmail
                case .invalidCredential:
                    throw SignInUserError.invalidCredential
                case .wrongPassword:
                    throw SignInUserError.wrongPassword
                case .userDisabled:
                    throw SignInUserError.userDisabled
                case .networkError:
                    throw SignInUserError.networkError
                default:
                    throw SignInUserError.unknownError
                }
            } else {
                throw SignInUserError.unknownError
            }
        }
    }
    
    func deleteUser() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw DeleteUserError.userNotFound
        }
        do {
            try await currentUser.delete()
        } catch {
            throw DeleteUserError.deleteFailed
        }
    }
    
    func signOutUser() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw SignOutUserError.signOutFailed
        }
    }
    
}
