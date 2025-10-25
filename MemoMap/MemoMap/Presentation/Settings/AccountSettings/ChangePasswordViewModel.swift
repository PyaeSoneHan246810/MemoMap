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
                "Unknown Error"
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
