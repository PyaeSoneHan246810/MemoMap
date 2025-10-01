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
    
    var password: String = ""
    
    private(set) var signInUserError: SignInUserError? = nil
    
    var trimmedEmailAddress: String {
        emailAddress.trimmed()
    }
    
    var trimmedPassword: String {
        password.trimmed()
    }
    
    func signInUser() async -> Result<Void, Error> {
        do {
            try await authenticationRepository.signInUser(
                email: emailAddress,
                password: password
            )
            return .success(())
        } catch {
            if let signInUserError = error as? SignInUserError {
                print(signInUserError.localizedDescription)
                self.signInUserError = signInUserError
                return .failure(signInUserError)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
}
