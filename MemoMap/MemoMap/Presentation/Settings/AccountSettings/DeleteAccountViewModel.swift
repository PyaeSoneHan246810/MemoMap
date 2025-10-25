//
//  DeleteAccountViewModel.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class DeleteAccountViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    var isDeleteAccountConfirmationPresented: Bool = false
    
    private(set) var isDeleteAccountInProgress: Bool = false
    
    enum DeleteAccountError: Error, LocalizedError {
        case deleteUserError(DeleteUserError)
        case deleteUserProfileError(DeleteUserProfileError)
        case deleteProfilePhotoError(DeleteProfilePhotoError)
        case signOutUserError(SignOutUserError)
        case unknownError
        var errorDescription: String? {
            switch self {
            case .deleteUserError(let deleteUserError):
                deleteUserError.localizedDescription
            case .deleteUserProfileError(let deleteUserProfileError):
                deleteUserProfileError.localizedDescription
            case .deleteProfilePhotoError(let deleteProfilePhotoError):
                deleteProfilePhotoError.localizedDescription
            case .signOutUserError(let signOutUserError):
                signOutUserError.localizedDescription
            case .unknownError:
                "Unknown Error"
            }
        }
    }
    
    private(set) var deleteAccountError: DeleteAccountError? = nil
    
    var isDeleteAccountAlertPresented: Bool = false
    
    func deleteAccount(onSuccess: () -> Void) async {
        isDeleteAccountInProgress = true
        do {
            let userData = authenticationRepository.getUserData()
            try await authenticationRepository.deleteUser()
            try await userProfileRepository.deleteUserProfile(userData: userData)
            try await storageRepository.deleteProfilePhoto(userData: userData)
            try authenticationRepository.signOutUser()
            isDeleteAccountInProgress = false
            deleteAccountError = nil
            isDeleteAccountAlertPresented = false
            onSuccess()
        } catch {
            isDeleteAccountInProgress = false
            if let deleteUserError = error as? DeleteUserError {
                deleteAccountError = .deleteUserError(deleteUserError)
            } else if let deleteUserProfileError = error as? DeleteUserProfileError{
                deleteAccountError = .deleteUserProfileError(deleteUserProfileError)
            } else if let deleteProfilePhotoError = error as? DeleteProfilePhotoError {
                deleteAccountError = .deleteProfilePhotoError(deleteProfilePhotoError)
            } else if let signOutUserError = error as? SignOutUserError {
                deleteAccountError = .signOutUserError(signOutUserError)
            } else {
                deleteAccountError = .unknownError
            }
            isDeleteAccountAlertPresented = true
        }
    }

}
