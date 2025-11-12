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
    
    var areCredentialsValid: Bool {
        isEmailValid && isPasswordValid
    }
    
    private var isEmailValid: Bool {
        validateEmail()
    }
    
    private func validateEmail() -> Bool {
        if trimmedEmailAddress.isEmpty {
            return false
        }
        if trimmedEmailAddress.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: trimmedEmailAddress)
    }
    
    private var isPasswordValid: Bool {
        passwordHasEightCharsOrMore && passwordHasAtLeastOneUppercaseChar && passwordHasAtLeastOneLowercaseChar && passwordHasAtLeastOneNumericChar && passwordHasAtLeastOneSpecialChar && isConfirmPasswordCorrect
    }
    
    var passwordHasEightCharsOrMore: Bool {
        trimmedPassword.count >= 8
    }
    
    var passwordHasAtLeastOneUppercaseChar: Bool {
        trimmedPassword.contains { $0.isUppercase }
    }
    
    var passwordHasAtLeastOneLowercaseChar: Bool {
        trimmedPassword.contains { $0.isLowercase }
    }
    
    var passwordHasAtLeastOneNumericChar: Bool {
        trimmedPassword.contains { $0.isNumber }
    }
    
    var passwordHasAtLeastOneSpecialChar: Bool {
        trimmedPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "^$*.[]{}()?\"!@#%&/\\,><':;|_~")) != nil
    }
    
    private var isConfirmPasswordCorrect: Bool {
        trimmedPassword == trimmedConfirmPassword
    }
    
    var showInvalidEmailMessage: Bool {
        !trimmedEmailAddress.isEmpty && !isEmailValid
    }
    
    var showPasswordValidationMessages: Bool {
        !trimmedPassword.isEmpty
    }
    
    var showPasswordMismatchMessage: Bool {
        !trimmedPassword.isEmpty && !trimmedConfirmPassword.isEmpty && !isConfirmPasswordCorrect
    }
    
    var isProfileInfoValid: Bool {
        isDisplayNameValid && isUsernameValid
    }
    
    private var isDisplayNameValid: Bool {
        !trimmedDisplayname.isEmpty
    }
    
    private var isUsernameValid: Bool {
        trimmedUsername.count >= 5 && trimmedUsername.count <= 20
    }
    
    var showUsernameValidationMessage: Bool {
        !trimmedUsername.isEmpty && !isUsernameValid
    }
    
    func normalizeUsername() {
        let username = createAccountInfo.username
        let cleanedUsername = username
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
            .filter { $0.isLetter || $0.isNumber || $0 == "_" }
        if cleanedUsername != username {
            createAccountInfo.username = cleanedUsername
        }
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
                "Something went wrong. Please try again later."
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
        let profilePhotoUrlString = try? await storageRepository.uploadProfilePhoto(data: data, userId: userId)
        return profilePhotoUrlString
    }
    
    private func saveUserProfile(userData: UserData, profilePhotoUrl: String?) async throws {
        let userProfileData = UserProfileData(
            id: userData.uid,
            emailAddress: userData.email ?? trimmedEmailAddress,
            username: "@\(trimmedUsername)",
            displayname: trimmedDisplayname,
            profilePhotoUrl: profilePhotoUrl,
            coverPhotoUrl: nil,
            birthday: birthday,
            bio: trimmedBio.isEmpty ? nil : trimmedBio,
            createdAt: .now
        )
        try await userProfileRepository.saveUserProfile(userProfileData: userProfileData)
    }
    
    private func deleteProfilePhoto() async {
        let user = authenticationRepository.getUserData()
        try? await storageRepository.deleteProfilePhoto(userData: user)
    }
    
    private func deleteUser() async {
        try? await authenticationRepository.deleteUser()
    }
    
    private func signOutUser() {
        try? authenticationRepository.signOutUser()
    }
    
    private func sendEmailVerification() async {
        try? await authenticationRepository.sendEmailVerification()
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
