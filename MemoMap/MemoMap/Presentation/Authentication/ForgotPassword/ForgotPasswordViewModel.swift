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
    
    var isSuccessSheetPresented: Bool = false
    
    private(set) var sendPasswordResetError: SendPasswordResetError? = nil
    
    private var trimmedEmailAddress: String {
        emailAddress.trimmed()
    }
    
    func sendPasswordReset() async {
        do {
            try await authenticationRepository.sendPasswordReset(email: trimmedEmailAddress)
            isSuccessSheetPresented = true
        } catch {
            if let sendPasswordResetError = error as? SendPasswordResetError {
                print(sendPasswordResetError.localizedDescription)
                self.sendPasswordResetError = sendPasswordResetError
            } else {
                print(error.localizedDescription)
            }
        }
    }
}
