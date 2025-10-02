//
//  CreateAccountViewModel.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import SwiftUI
import Observation
import PhotosUI
import Factory

@Observable
final class CreateAccountViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    var createAccountInfo: CreateAccountInfo = .init()
    
    var currentCreateAccountSection: CreateAccountSection = .accountInfo
    
    private(set) var createUserError: CreateUserError? = nil

    private(set) var saveUserProfileError: SaveUserProfileError? = nil
    
    private var trimmedEmailAddress: String {
        createAccountInfo.emailAddress.trimmed()
    }
    
    private var trimmedPassword: String {
        createAccountInfo.password.trimmed()
    }
    
    private var trimmedConfirmPassword: String {
        createAccountInfo.confirmPassword.trimmed()
    }
    
    private var trimmedDisplayname: String {
        createAccountInfo.displayName.trimmed()
    }
    
    private var trimmedUsername: String {
        createAccountInfo.username.trimmed()
    }
    
    private var trimmedBio: String {
        createAccountInfo.bio.trimmed()
    }
    
    private var birthday: Date {
        createAccountInfo.birthday
    }
    
    private var profilePhotoImage: UIImage? {
        createAccountInfo.profilePhotoImage
    }
    
    func signUpUser() async -> Result<Void, Error> {
        do {
            let user = try await createUser()
            var profilePhotoUrl: String? = nil
            profilePhotoUrl = await uploadProfilePhoto(userId: user.uid)
            try await saveUserProfile(
                user: user,
                profilePhotoUrl: profilePhotoUrl
            )
            await sendEmailVerification()
            return .success(())
        } catch {
            if let createUserError = error as? CreateUserError {
                print(createUserError.localizedDescription)
                self.createUserError = createUserError
                return .failure(createUserError)
            } else if let saveUserProfileError = error as? SaveUserProfileError {
                print(saveUserProfileError.localizedDescription)
                self.saveUserProfileError = saveUserProfileError
                if case .saveFailed = saveUserProfileError {
                    await deleteUser()
                    signOutUser()
                }
                return .failure(saveUserProfileError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
    
    private func createUser() async throws -> UserModel {
        let user = try await authenticationRepository.createUser(
            email: trimmedEmailAddress,
            password: trimmedConfirmPassword
        )
        return user
    }
    
    private func uploadProfilePhoto(userId: String) async -> String? {
        guard let profilePhotoImage, let data = profilePhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let profilePhotoUrl = try await storageRepository.uploadProfilePhoto(data: data, userId: userId)
            return profilePhotoUrl
        } catch {
            if let uploadProfilePhotoError = error as? UploadProfilePhotoError {
                print(uploadProfilePhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func saveUserProfile(user: UserModel, profilePhotoUrl: String?) async throws {
        let userProfile = UserProfileModel(
            id: user.uid,
            emailAddress: user.email,
            username: "@\(trimmedUsername)",
            displayname: trimmedDisplayname,
            profilePhotoUrl: profilePhotoUrl,
            coverPhotoUrl: nil,
            birthday: birthday,
            bio: trimmedBio,
            createdAt: Date.now
        )
        try await userProfileRepository.saveUserProfile(userProfile: userProfile)
    }
    
    private func deleteUser() async {
        do {
            try await authenticationRepository.deleteUser()
        } catch {
            if let deleteUserError = error as? DeleteUserError {
                print(deleteUserError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func signOutUser() {
        do {
            try authenticationRepository.signOutUser()
        } catch {
            if let signOutUserError = error as? SignOutUserError {
                print(signOutUserError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func sendEmailVerification() async {
        do {
            try await authenticationRepository.sendEmailVerification()
        } catch {
            if let sendEmailVerificationError = error as? SendEmailVerificationError {
                print(sendEmailVerificationError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}

extension CreateAccountViewModel {
    enum CreateAccountSection {
        case accountInfo
        case profileInfo
    }
    
    struct CreateAccountInfo {
        var emailAddress: String = ""
        var password: String = ""
        var confirmPassword: String = ""
        var profilePhotoPickerItem: PhotosPickerItem? = nil
        var profilePhotoImage: UIImage? = nil
        var displayName: String = ""
        var username: String = ""
        var birthday: Date = .now
        var bio: String = ""
    }
}
