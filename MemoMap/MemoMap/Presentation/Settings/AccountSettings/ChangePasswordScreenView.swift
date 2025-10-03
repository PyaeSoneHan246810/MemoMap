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
        VStack(spacing: 20.0) {
            passwordTextFieldsView
            updateButtonView
            Spacer()
        }
        .padding(16.0)
        .navigationTitle("Change password")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ChangePasswordScreenView {
    @ViewBuilder
    var passwordTextFieldsView: some View {
        InputTextFieldView(
            title: "Current password",
            placeholder: "Enter your current password",
            text: $changePasswordViewModel.currentPassword,
            isSecured: true
        )
        InputTextFieldView(
            title: "New password",
            placeholder: "Enter your new password",
            text: $changePasswordViewModel.newPassword,
            isSecured: true
        )
        InputTextFieldView(
            title: "Confirm new password",
            placeholder: "Confirm your new password",
            text: $changePasswordViewModel.confirmNewPassword,
            isSecured: true
        )
    }
    var updateButtonView: some View {
        Button {
            Task { await updatePassword() }
        } label: {
            Text("Update")
        }
        .primaryFilledLargeButtonStyle()
    }
}

private extension ChangePasswordScreenView {
    func updatePassword() async {
        let result = await changePasswordViewModel.reauthenticateUserAndUpdatePassword()
        if case .success = result {
            appSessionViewModel.changeAppSession(.unauthenticated)
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        ChangePasswordScreenView()
    }
    .environment(appSessionViewModel)
}
