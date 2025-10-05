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
    
    private(set) var reloadUserError: ReloadUserError? = nil
    
    private(set) var sendEmailVerificationError: SendEmailVerificationError? = nil
    
    func checkEmailVerificationStatus() async -> EmailVerificationStatus {
        do {
            try await authenticationRepository.reloadUser()
            guard let userData = authenticationRepository.getUserData() else {
                return .unknown
            }
            return userData.isEmailVerified ? .verified : .notVerified
        } catch {
            if let reloadUserError = error as? ReloadUserError {
                print(reloadUserError.localizedDescription)
                self.reloadUserError = reloadUserError
            } else {
                print(error.localizedDescription)
            }
            return .unknown
        }
    }
    
    func sendEmailVerification() async {
        do {
            try await authenticationRepository.sendEmailVerification()
        } catch {
            if let sendEmailVerificationError = error as? SendEmailVerificationError {
                print(sendEmailVerificationError.localizedDescription)
                self.sendEmailVerificationError = sendEmailVerificationError
            } else {
                print(error.localizedDescription)
            }
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
