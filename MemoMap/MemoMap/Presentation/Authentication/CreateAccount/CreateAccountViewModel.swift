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
    
    var currentCreateAccountSection: CreateAccountSection = .accountInfo
    
    var createAccountInfo: CreateAccountInfo = .init()
    
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
    
    private(set) var isSignUpUserInProgress: Bool = false
    
    enum SignUpUserError: Error, LocalizedError {
        case usernameAvailabilitError(UsernameAvailabilityError)
        case createUserError(CreateUserError)
        case saveUserProfileError(SaveUserProfileError)
        case unknownError
        var errorDescription: String? {
            switch self {
            case .usernameAvailabilitError(let usernameAvailabilityError):
                usernameAvailabilityError.localizedDescription
            case .createUserError(let createUserError):
                createUserError.localizedDescription
            case .saveUserProfileError(let saveUserProfileError):
                saveUserProfileError.localizedDescription
            case .unknownError:
                "Unknown Error"
            }
        }
    }
    
    private(set) var signUpUserError: SignUpUserError? = nil
    
    var isSignUpUserAlertPresented: Bool = false
    
    func signUpUser(onSuccess: () -> Void) async {
        isSignUpUserInProgress = true
        do {
            try await userProfileRepository.checkUsernameAvailability(
                username: "@\(trimmedUsername)"
            )
            let userData = try await createUser()
            let profilePhotoUrlString = await uploadProfilePhoto(userId: userData.uid)
            try await saveUserProfile(
                userData: userData,
                profilePhotoUrl: profilePhotoUrlString
            )
            await sendEmailVerification()
            isSignUpUserInProgress = false
            signUpUserError = nil
            isSignUpUserAlertPresented = false
            onSuccess()
        } catch {
            isSignUpUserInProgress = false
            if let usernameAvailabilityError = error as? UsernameAvailabilityError {
                signUpUserError = .usernameAvailabilitError(usernameAvailabilityError)
            } else if let createUserError = error as? CreateUserError {
                signUpUserError = .createUserError(createUserError)
            } else if let saveUserProfileError = error as? SaveUserProfileError {
                if case .saveFailed = saveUserProfileError {
                    await deleteProfilePhoto()
                    await deleteUser()
                    signOutUser()
                }
                signUpUserError = .saveUserProfileError(saveUserProfileError)
            } else {
                signUpUserError = .unknownError
            }
            isSignUpUserAlertPresented = true
        }
    }
    
    private func createUser() async throws -> UserData {
        let userData = try await authenticationRepository.createUser(
            email: trimmedEmailAddress,
            password: trimmedConfirmPassword
        )
        return userData
    }
    
    private func uploadProfilePhoto(userId: String) async -> String? {
        guard let profilePhotoImage, let data = profilePhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let profilePhotoUrlString = try await storageRepository.uploadProfilePhoto(data: data, userId: userId)
            return profilePhotoUrlString
        } catch {
            if let uploadProfilePhotoError = error as? UploadProfilePhotoError {
                print(uploadProfilePhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func saveUserProfile(userData: UserData, profilePhotoUrl: String?) async throws {
        let userProfileData = UserProfileData(
            id: userData.uid,
            emailAddress: userData.email ?? "",
            username: "@\(trimmedUsername)",
            displayname: trimmedDisplayname,
            profilePhotoUrl: profilePhotoUrl,
            coverPhotoUrl: nil,
            birthday: birthday,
            bio: trimmedBio,
            createdAt: .now
        )
        try await userProfileRepository.saveUserProfile(userProfileData: userProfileData)
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
    
    private func deleteProfilePhoto() async {
        let user = authenticationRepository.getUserData()
        do {
            try await storageRepository.deleteProfilePhoto(userData: user)
        } catch {
            if let deleteProfilePhotoError = error as? DeleteProfilePhotoError {
                print(deleteProfilePhotoError.localizedDescription)
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
