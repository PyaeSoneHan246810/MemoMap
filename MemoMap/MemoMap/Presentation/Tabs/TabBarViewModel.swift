//
//  TabBarViewModel.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class TabBarViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    private(set) var isUserEmailVerified: Bool = false
    
    var isVerifyAccountSheetPresented: Bool = false
    
    private(set) var reloadUserError: ReloadUserError? = nil
    
    func checkEmailVerificationStatus() async {
        do {
            try await authenticationRepository.reloadUser()
            if let userData = authenticationRepository.getUserData() {
                isUserEmailVerified = userData.isEmailVerified
            }
        } catch {
            if let reloadUserError = error as? ReloadUserError {
                print(reloadUserError.localizedDescription)
                self.reloadUserError = reloadUserError
            } else {
                print(error.localizedDescription)
            }
        }
        isVerifyAccountSheetPresented = !isUserEmailVerified
    }
}
