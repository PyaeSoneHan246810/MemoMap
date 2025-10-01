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
    
    private(set) var signOutUserError: SignOutUserError? = nil
    
    func logoutUser() -> Result<Void, Error> {
        do {
            try authenticationRepository.signOutUser()
            return .success(())
        } catch {
            if let signOutUserError = error as? SignOutUserError {
                print(signOutUserError.localizedDescription)
                self.signOutUserError = signOutUserError
                return .failure(error)
            } else {
                print(error.localizedDescription)
                return .failure(error)
            }
        }
    }
}
