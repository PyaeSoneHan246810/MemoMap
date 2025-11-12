//
//  ChangePasswordViewModel.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class ChangePasswordViewModel {
    
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    var currentPassword: String = ""
    
    private var trimmedCurrentPassword: String {
        currentPassword.trimmed()
    }
    
    var newPassword: String = ""
    
    private var trimmedNewPassword: String {
        newPassword.trimmed()
    }
    
    var confirmNewPassword: String = ""
    
    private var trimmedConfirmNewPassword: String {
        confirmNewPassword.trimmed()
    }
    
    var isChangePasswordValid: Bool {
        isCurrentPasswordVaid && isNewPasswordValid
    }
    
    var isCurrentPasswordVaid: Bool {
        !currentPassword.isEmpty
    }
    
    private var isNewPasswordValid: Bool {
        passwordHasEightCharsOrMore && passwordHasAtLeastOneUppercaseChar && passwordHasAtLeastOneLowercaseChar && passwordHasAtLeastOneNumericChar && passwordHasAtLeastOneSpecialChar && isConfirmPasswordCorrect
    }
    
    var passwordHasEightCharsOrMore: Bool {
        trimmedNewPassword.count >= 8
    }
    
    var passwordHasAtLeastOneUppercaseChar: Bool {
        trimmedNewPassword.contains { $0.isUppercase }
    }
    
    var passwordHasAtLeastOneLowercaseChar: Bool {
        trimmedNewPassword.contains { $0.isLowercase }
    }
    
    var passwordHasAtLeastOneNumericChar: Bool {
        trimmedNewPassword.contains { $0.isNumber }
    }
    
    var passwordHasAtLeastOneSpecialChar: Bool {
        trimmedNewPassword.rangeOfCharacter(from: CharacterSet(charactersIn: "^$*.[]{}()?\"!@#%&/\\,><':;|_~")) != nil
    }
    
    private var isConfirmPasswordCorrect: Bool {
        trimmedNewPassword == trimmedConfirmNewPassword
    }
    
    var showNewPasswordValidationMessages: Bool {
        !trimmedNewPassword.isEmpty
    }
    
    var showNewPasswordMismatchMessage: Bool {
        !trimmedNewPassword.isEmpty && !trimmedConfirmNewPassword.isEmpty && !isConfirmPasswordCorrect
    }
    
    private(set) var isChangePasswordInProgress: Bool = false
    
    enum ChangePasswordError: Error, LocalizedError {
        case reauthenticateUserError(ReauthenticateUserError)
        case updatePasswordError(UpdatePasswordError)
        case unknownError
        var errorDescription: String? {
            switch self {
            case .reauthenticateUserError(let reauthenticateUserError):
                reauthenticateUserError.localizedDescription
            case .updatePasswordError(let updatePasswordError):
                updatePasswordError.localizedDescription
            case .unknownError:
                "Something went wrong. Please try again later."
            }
        }
    }
    
    private(set) var changePasswordError: ChangePasswordError? = nil
    
    var isChangePasswordAlertPresented: Bool = false
    
    func changePassword(onSuccess: () -> Void) async {
        isChangePasswordInProgress = true
        do {
            try await authenticationRepository.reauthenticateUser(currentPassword: trimmedCurrentPassword)
            try await authenticationRepository.updatePassword(newPassword: trimmedConfirmNewPassword)
            isChangePasswordInProgress = false
            changePasswordError = nil
            isChangePasswordAlertPresented = false
            onSuccess()
        } catch {
            isChangePasswordInProgress = false
            if let reauthenticateUserError = error as? ReauthenticateUserError {
                changePasswordError = .reauthenticateUserError(reauthenticateUserError)
            } else if let updatePasswordError = error as? UpdatePasswordError {
                changePasswordError = .updatePasswordError(updatePasswordError)
            } else {
                changePasswordError = .unknownError
            }
            isChangePasswordAlertPresented = true
        }
    }
}
