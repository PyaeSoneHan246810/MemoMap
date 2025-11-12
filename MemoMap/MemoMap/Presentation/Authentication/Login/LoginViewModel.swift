//
//  LoginViewModel.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class LoginViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    var emailAddress: String = ""
    
    private var trimmedEmailAddress: String {
        emailAddress.trimmed()
    }
    
    var password: String = ""
    
    private var trimmedPassword: String {
        password.trimmed()
    }
    
    var isSignInValid: Bool {
        !trimmedEmailAddress.isEmpty && !trimmedPassword.isEmpty
    }
    
    private(set) var isSignInUserInProgress: Bool = false
    
    private(set) var signInUserError: SignInUserError? = nil
    
    var isSignInUserAlertPresented: Bool = false
    
    func signInUser(onSuccess: () -> Void) async {
        isSignInUserInProgress = true
        do {
            try await authenticationRepository.signInUser(
                email: trimmedEmailAddress,
                password: trimmedPassword
            )
            isSignInUserInProgress = false
            signInUserError = nil
            isSignInUserAlertPresented = false
            onSuccess()
        } catch {
            isSignInUserInProgress = false
            if let signInUserError = error as? SignInUserError {
                self.signInUserError = signInUserError
            } else {
                signInUserError = .unknownError
            }
            isSignInUserAlertPresented = true
        }
    }
}
