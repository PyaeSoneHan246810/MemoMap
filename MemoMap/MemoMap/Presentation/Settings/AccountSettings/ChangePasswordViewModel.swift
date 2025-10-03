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
    
    var newPassword: String = ""
    
    var confirmNewPassword: String = ""
    
    private(set) var reauthenticateUserError: ReauthenticateUserError? = nil
    
    private(set) var updatePasswordError: UpdatePasswordError? = nil
    
    private var trimmedCurrentPassword: String {
        currentPassword.trimmed()
    }
    
    private var trimmedNewPassword: String {
        newPassword.trimmed()
    }
    
    private var trimmedConfirmNewPassword: String {
        confirmNewPassword.trimmed()
    }
    
    func reauthenticateUserAndUpdatePassword() async -> Result<Void, Error> {
        do {
            try await authenticationRepository.reauthenticateUser(currentPassword: trimmedCurrentPassword)
            try await authenticationRepository.updatePassword(newPassword: trimmedConfirmNewPassword)
            return .success(())
        } catch {
            if let reauthenticateUserError = error as? ReauthenticateUserError {
                print(reauthenticateUserError.localizedDescription)
                return .failure(reauthenticateUserError)
            } else if let updatePasswordError = error as? UpdatePasswordError {
                print(updatePasswordError.localizedDescription)
                return .failure(updatePasswordError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
}
