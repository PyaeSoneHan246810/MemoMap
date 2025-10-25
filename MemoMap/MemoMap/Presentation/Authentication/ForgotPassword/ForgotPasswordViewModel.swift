//
//  ForgotPasswordViewModel.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class ForgotPasswordViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    var emailAddress: String = ""
    
    private var trimmedEmailAddress: String {
        emailAddress.trimmed()
    }
    
    private(set) var isPasswordResetInProgress: Bool = false
    
    private(set) var sendPasswordResetError: SendPasswordResetError? = nil
    
    var isPasswordResetAlertPresented: Bool = false
    
    var isSuccessSheetPresented: Bool = false
    
    func sendPasswordReset() async {
        isPasswordResetInProgress = true
        do {
            try await authenticationRepository.sendPasswordReset(email: trimmedEmailAddress)
            isPasswordResetInProgress = false
            sendPasswordResetError = nil
            isPasswordResetAlertPresented = false
            isSuccessSheetPresented = true
        } catch {
            isPasswordResetInProgress = false
            if let sendPasswordResetError = error as? SendPasswordResetError {
                self.sendPasswordResetError = sendPasswordResetError
            } else {
                sendPasswordResetError = .unknownError
            }
            isPasswordResetAlertPresented = true
            isSuccessSheetPresented = false
        }
    }
}
