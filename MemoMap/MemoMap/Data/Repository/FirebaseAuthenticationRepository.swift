//
//  FirebaseAuthenticationRepository.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthenticationRepository: AuthenticationRepository {
    
    func getUserData() -> UserData? {
        guard let currentUser = Auth.auth().currentUser else { return nil }
        let userData = getUserData(from: currentUser)
        return userData
    }
    
    func reloadUser() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw ReloadUserError.userNotFound
        }
        do {
            try await currentUser.reload()
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .userNotFound:
                    throw ReloadUserError.userNotFound
                case .networkError:
                    throw ReloadUserError.networkError
                default:
                    throw ReloadUserError.unknownError
                }
            } else {
                throw ReloadUserError.unknownError
            }
        }
    }
    
    func createUser(email: String, password: String) async throws -> UserData {
        do {
            let authDataResult = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            let userData = getUserData(from: authDataResult.user)
            return userData
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
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .requiresRecentLogin:
                    throw DeleteUserError.requiresRecentLogin
                default:
                    throw DeleteUserError.unknownError
                }
            } else {
                throw DeleteUserError.unknownError
            }
        }
    }
    
    func signOutUser() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .keychainError:
                    throw SignOutUserError.keychainError
                default:
                    throw SignOutUserError.unknownError
                }
            } else {
                throw SignOutUserError.unknownError
            }
        }
    }
    
    func sendEmailVerification() async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw SendEmailVerificationError.userNotFound
        }
        do {
            try await currentUser.sendEmailVerification()
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .userNotFound:
                    throw SendEmailVerificationError.userNotFound
                case .networkError:
                    throw SendEmailVerificationError.networkError
                default:
                    throw SendEmailVerificationError.unknownError
                }
            } else {
                throw SendEmailVerificationError.unknownError
            }
        }
    }
    
    func sendPasswordReset(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .invalidEmail:
                    throw SendPasswordResetError.invalidEmail
                case .networkError:
                    throw SendPasswordResetError.networkError
                default:
                    throw SendPasswordResetError.sendFailed
                }
            } else {
                throw SendPasswordResetError.unknownError
            }
        }
    }
    
    func reauthenticateUser(currentPassword: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw ReauthenticateUserError.userNotFound
        }
        guard let currentUserEmail = currentUser.email else {
            throw ReauthenticateUserError.userEmailNotFound
        }
        let authCredential = EmailAuthProvider.credential(withEmail: currentUserEmail, password: currentPassword)
        do {
            try await currentUser.reauthenticate(with: authCredential)
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .invalidCredential:
                    throw ReauthenticateUserError.invalidCredential
                case .invalidEmail:
                    throw ReauthenticateUserError.invalidEmail
                case .wrongPassword:
                    throw ReauthenticateUserError.wrongPassword
                case .userMismatch:
                    throw ReauthenticateUserError.userMismatch
                case .userDisabled:
                    throw ReauthenticateUserError.userDisabled
                case .networkError:
                    throw ReauthenticateUserError.networkError
                default:
                    throw ReauthenticateUserError.unknownError
                }
            } else {
                throw ReauthenticateUserError.unknownError
            }
        }
    }
    
    func updatePassword(newPassword: String) async throws {
        guard let currentUser = Auth.auth().currentUser else {
            throw UpdatePasswordError.userNotFound
        }
        do {
            try await currentUser.updatePassword(to: newPassword)
        } catch {
            if let nsError = error as NSError? {
                let errorCode = AuthErrorCode(rawValue: nsError.code)
                switch errorCode {
                case .operationNotAllowed:
                    throw UpdatePasswordError.operationNotAllowed
                case .requiresRecentLogin:
                    throw UpdatePasswordError.requiresRecentLogin
                case .weakPassword:
                    throw UpdatePasswordError.weakPassword
                case .networkError:
                    throw UpdatePasswordError.networkError
                default:
                    throw UpdatePasswordError.unknownError
                }
            }
        }
    }
    
}

private extension FirebaseAuthenticationRepository {
    private func getUserData(from user: User) -> UserData {
        UserData(uid: user.uid, email: user.email, isEmailVerified: user.isEmailVerified)
    }
}
