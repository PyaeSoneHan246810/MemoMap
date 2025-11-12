//
//  VerifyAccountViewModel.swift
//  MemoMap
//
//  Created by Dylan on 1/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class VerifyAccountViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    private(set) var isReloadUserInProgress: Bool = false
    
    private(set) var reloadUserError: ReloadUserError? = nil
    
    var isReloadUserAlertPresented: Bool = false
    
    private(set) var isSendEmailVerificationInProgress: Bool = false
    
    private(set) var sendEmailVerificationError: SendEmailVerificationError? = nil
    
    var isSendEmailVerificationAlertPresented: Bool = false
    
    func checkEmailVerificationStatus() async -> EmailVerificationStatus {
        isReloadUserInProgress = true
        do {
            try await authenticationRepository.reloadUser()
            guard let userData = authenticationRepository.getUserData() else {
                isReloadUserInProgress = false
                reloadUserError = .userNotFound
                isReloadUserAlertPresented = true
                return .unknown
            }
            isReloadUserInProgress = false
            reloadUserError = nil
            isReloadUserAlertPresented = false
            return userData.isEmailVerified ? .verified : .notVerified
        } catch {
            isReloadUserInProgress = false
            if let reloadUserError = error as? ReloadUserError {
                self.reloadUserError = reloadUserError
            } else {
                reloadUserError = .unknownError
            }
            isReloadUserAlertPresented = true
            return .unknown
        }
    }
    
    func sendEmailVerification() async {
        isSendEmailVerificationInProgress = true
        do {
            try await authenticationRepository.sendEmailVerification()
            isSendEmailVerificationInProgress = false
            sendEmailVerificationError = nil
            isSendEmailVerificationAlertPresented = false
        } catch {
            isSendEmailVerificationInProgress = false
            if let sendEmailVerificationError = error as? SendEmailVerificationError {
                self.sendEmailVerificationError = sendEmailVerificationError
            } else {
                sendEmailVerificationError = .unknownError
            }
            isSendEmailVerificationAlertPresented = true
        }
    }
    
    func logOutUser(onSuccess: () -> Void) {
        do {
            try authenticationRepository.signOutUser()
            onSuccess()
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension VerifyAccountViewModel {
    enum EmailVerificationStatus {
        case verified
        case notVerified
        case unknown
    }
}
