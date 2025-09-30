//
//  CreateAccountViewModel.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Observation
import SwiftUI
import PhotosUI
import Factory

@Observable
final class CreateAccountViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
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
            do {
                profilePhotoUrl = try await uploadProfilePhoto(userId: user.uid)
            } catch {
                if let uploadProfilePhotoError = error as? UploadProfilePhotoError {
                    print(uploadProfilePhotoError.localizedDescription)
                }
            }
            try await saveUserProfile(
                user: user,
                profilePhotoUrl: profilePhotoUrl
            )
            return .success(())
        } catch {
            if let createUserError = error as? CreateUserError {
                self.createUserError = createUserError
                return .failure(createUserError)
            } else if let saveUserProfileError = error as? SaveUserProfileError {
                self.saveUserProfileError = saveUserProfileError
                if case .databaseError = saveUserProfileError {
                    await deleteUser()
                    signOutUser()
                }
                return .failure(saveUserProfileError)
            } else {
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
    
    private func uploadProfilePhoto(userId: String) async throws -> String? {
        guard let profilePhotoImage, let data = profilePhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let profilePhotoUrl = try await storageRepository.uploadProfilePhoto(data: data, userId: userId)
        return profilePhotoUrl
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
            print(error.localizedDescription)
        }
    }
    
    private func signOutUser() {
        do {
            try authenticationRepository.signOutUser()
        } catch {
            print(error.localizedDescription)
        }
    }
}
