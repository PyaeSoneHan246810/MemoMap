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
    
    var isVerifyAccountSheetPresented: Bool = false
    
    private(set) var isReloadUserInProgress: Bool = false
    
    private(set) var reloadUserError: ReloadUserError? = nil
    
    var isReloadUserAlertPresented: Bool = false
    
    func checkEmailVerificationStatus() async {
        isReloadUserInProgress = true
        do {
            try await authenticationRepository.reloadUser()
            isReloadUserInProgress = false
            if let userData = authenticationRepository.getUserData() {
                isVerifyAccountSheetPresented = !userData.isEmailVerified
                reloadUserError = nil
                isReloadUserAlertPresented = false
            } else {
                reloadUserError = .userNotFound
                isReloadUserAlertPresented = true
            }
        } catch {
            isReloadUserInProgress = false
            if let reloadUserError = error as? ReloadUserError {
                self.reloadUserError = reloadUserError
            } else {
                reloadUserError = .unknownError
            }
            isReloadUserAlertPresented = true
        }
    }
}
