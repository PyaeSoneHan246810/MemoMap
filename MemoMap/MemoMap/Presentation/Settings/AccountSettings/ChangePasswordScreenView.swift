//
//  ChangePasswordScreenView.swift
//  MemoMap
//
//  Created by Dylan on 2/10/25.
//

import SwiftUI

struct ChangePasswordScreenView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel: AppSessionViewModel
    @State private var changePasswordViewModel: ChangePasswordViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                passwordTextFieldsView
                updateButtonView
            }
            .animation(.smooth, value: changePasswordViewModel.showNewPasswordValidationMessages)
            .animation(.smooth, value: changePasswordViewModel.showNewPasswordMismatchMessage)
        }
        .scrollIndicators(.hidden)
        .contentMargins(16.0)
        .navigationTitle("Change password")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            isPresented: $changePasswordViewModel.isChangePasswordAlertPresented,
            error: changePasswordViewModel.changePasswordError
        ) {}
    }
}

private extension ChangePasswordScreenView {
    @ViewBuilder
    var passwordTextFieldsView: some View {
        InputTextFieldView(
            title: "Current password",
            placeholder: "Enter your current password",
            text: $changePasswordViewModel.currentPassword,
            isSecured: true,
            textContentType: .password,
            autoCorrectionDisabled: true,
            submitLabel: .next
        )
        VStack(alignment: .leading, spacing: 8.0) {
            InputTextFieldView(
                title: "New password",
                placeholder: "Enter your new password",
                text: $changePasswordViewModel.newPassword,
                isSecured: true,
                textContentType: .newPassword,
                autoCorrectionDisabled: true,
                submitLabel: .next
            )
            if changePasswordViewModel.showNewPasswordValidationMessages {
                passwordValidationMessagesView
            }
        }
        VStack(alignment: .leading, spacing: 8.0) {
            InputTextFieldView(
                title: "Confirm new password",
                placeholder: "Confirm your new password",
                text: $changePasswordViewModel.confirmNewPassword,
                isSecured: true,
                textContentType: .newPassword,
                autoCorrectionDisabled: true,
                submitLabel: .done
            )
            if changePasswordViewModel.showNewPasswordMismatchMessage {
                Text("Passwords do not match.")
                    .font(.callout)
                    .foregroundStyle(.red)
            }
        }
    }
    var passwordValidationMessagesView: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            PasswordValidationMessageView(
                isValid: changePasswordViewModel.passwordHasEightCharsOrMore,
                message: "8 characters or more"
            )
            PasswordValidationMessageView(
                isValid: changePasswordViewModel.passwordHasAtLeastOneUppercaseChar,
                message: "At least one uppercase character"
            )
            PasswordValidationMessageView(
                isValid: changePasswordViewModel.passwordHasAtLeastOneLowercaseChar,
                message: "At least one lowercase character"
            )
            PasswordValidationMessageView(
                isValid: changePasswordViewModel.passwordHasAtLeastOneNumericChar,
                message: "At least one numeric character"
            )
            PasswordValidationMessageView(
                isValid: changePasswordViewModel.passwordHasAtLeastOneSpecialChar,
                message: "At least one special character"
            )
        }
    }
    var updateButtonView: some View {
        Button {
            Task { await updatePassword() }
        } label: {
            Text("Update")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: changePasswordViewModel.isChangePasswordInProgress)
        .disabled(!changePasswordViewModel.isChangePasswordValid)
    }
}

private extension ChangePasswordScreenView {
    func updatePassword() async {
        await changePasswordViewModel.changePassword(
            onSuccess: {
                appSessionViewModel.changeAppSession(.unauthenticated)
            }
        )
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        ChangePasswordScreenView()
    }
    .environment(appSessionViewModel)
}
