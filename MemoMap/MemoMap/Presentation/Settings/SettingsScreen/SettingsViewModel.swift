//
//  SettingsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class SettingsViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    var isSignOutConfirmationPresented: Bool = false
    
    private(set) var isSignOutUserInProgress: Bool = false
    
    private(set) var signOutUserError: SignOutUserError? = nil
    
    var isSignOutUserAlertPresented: Bool = false
    
    func logoutUser(onSuccess: () -> Void) {
        isSignOutUserInProgress = true
        do {
            try authenticationRepository.signOutUser()
            isSignOutUserInProgress = false
            signOutUserError = nil
            isSignOutUserAlertPresented = false
            onSuccess()
        } catch {
            isSignOutUserInProgress = false
            if let signOutUserError = error as? SignOutUserError {
                self.signOutUserError = signOutUserError
            } else {
                signOutUserError = .unknownError
            }
            isSignOutUserAlertPresented = true
        }
    }
}
