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
            LazyVStack(spacing: 20.0) {
                passwordTextFieldsView
                updateButtonView
            }
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
            localizedTitle: "Current password",
            localizedPlaceholder: "Enter your current password",
            text: $changePasswordViewModel.currentPassword,
            isSecured: true,
            textContentType: .password,
            autoCorrectionDisabled: true,
            submitLabel: .next
        )
        InputTextFieldView(
            localizedTitle: "New password",
            localizedPlaceholder: "Enter your new password",
            text: $changePasswordViewModel.newPassword,
            isSecured: true,
            textContentType: .newPassword,
            autoCorrectionDisabled: true,
            submitLabel: .next
        )
        InputTextFieldView(
            localizedTitle: "Confirm new password",
            localizedPlaceholder: "Confirm your new password",
            text: $changePasswordViewModel.confirmNewPassword,
            isSecured: true,
            textContentType: .newPassword,
            autoCorrectionDisabled: true,
            submitLabel: .done
        )
    }
    var updateButtonView: some View {
        Button {
            Task { await updatePassword() }
        } label: {
            Text("Update")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: changePasswordViewModel.isChangePasswordInProgress)
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
