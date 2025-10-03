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
    
    private(set) var deleteUserProfileError: DeleteUserProfileError? = nil
    
    private(set) var deleteUserError: DeleteUserError? = nil
    
    private(set) var signOutUserError: SignOutUserError? = nil
    
    func deleteUser() async -> Result<Void, Error> {
        do {
            let user = authenticationRepository.getAuthenticatedUser()
            try await authenticationRepository.deleteUser()
            try authenticationRepository.signOutUser()
            await deleteUserInfo(user: user)
            return .success(())
        } catch {
            if let deleteUserError = error as? DeleteUserError {
                print(deleteUserError.localizedDescription)
                self.deleteUserError = deleteUserError
                return .failure(deleteUserError)
            } else if let signOutUserError = error as? SignOutUserError {
                print(signOutUserError.localizedDescription)
                self.signOutUserError = signOutUserError
                return .failure(signOutUserError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
    
    private func deleteUserInfo(user: UserModel?) async {
        do {
            try await userProfileRepository.deleteUserProfile(user: user)
        } catch {
            if let deleteUserProfileError = error as? DeleteUserProfileError {
                print(deleteUserProfileError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
        do {
            try await storageRepository.deleteProfilePhoto(user: user)
        } catch {
            if let deleteProfilePhotoError = error as? DeleteProfilePhotoError {
                print(deleteProfilePhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
