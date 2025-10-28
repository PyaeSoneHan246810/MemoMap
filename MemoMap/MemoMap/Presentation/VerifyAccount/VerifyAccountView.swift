//
//  VerifyAccountView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct VerifyAccountView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel
    @State private var verifyAccountViewModel: VerifyAccountViewModel = .init()
    @Binding var isPresented: Bool
    var body: some View {
        VStack(spacing: 0.0) {
            Spacer().frame(height: 20.0)
            logoView
            Spacer().frame(height: 80.0)
            verificationInfoView
            Spacer()
            buttonsView
            Spacer().frame(height: 80.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16.0)
        .alert(
            isPresented: $verifyAccountViewModel.isReloadUserAlertPresented,
            error: verifyAccountViewModel.reloadUserError
        ) {
            if case .userNotFound = verifyAccountViewModel.reloadUserError {
                logOutAlertButtonView
            }
        }
        .alert(
            isPresented: $verifyAccountViewModel.isSendEmailVerificationAlertPresented,
            error: verifyAccountViewModel.sendEmailVerificationError
        ) {
            if case .userNotFound = verifyAccountViewModel.reloadUserError {
                logOutAlertButtonView
            }
        }
    }
}

private extension VerifyAccountView {
    var logoView: some View {
        Image(.appLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 160.0)
    }
    var verificationInfoView: some View {
        VStack(spacing: 40.0) {
            Image(.verifyAccount)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
                .foregroundStyle(.accent)
            VStack(spacing: 12.0) {
                Text("Verify your account")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Please check your email for an account verification link to be able to use our app.")
                    .font(.callout)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    var buttonsView: some View {
        VStack(spacing: 12.0) {
            Button {
                Task {
                    await checkEmailVerificationStatus()
                }
            } label: {
                Text("I've verified")
            }
            .primaryFilledLargeButtonStyle()
            .progressButtonStyle(isInProgress: verifyAccountViewModel.isReloadUserInProgress)
            Button {
                Task {
                    await verifyAccountViewModel.sendEmailVerification()
                }
            } label: {
                Text("Resend verification link")
                    .frame(maxWidth: .infinity)
            }
            .textLargeButtonStyle()
            .progressButtonStyle(isInProgress: verifyAccountViewModel.isSendEmailVerificationInProgress)
        }
    }
    var logOutAlertButtonView: some View {
        Button("Log out") {
            verifyAccountViewModel.logOutUser(
                onSuccess: {
                    appSessionViewModel.changeAppSession(.unauthenticated)
                }
            )
        }
    }
}

private extension VerifyAccountView {
    func checkEmailVerificationStatus() async {
        let emailVerificationStatus = await verifyAccountViewModel.checkEmailVerificationStatus()
        if case .verified = emailVerificationStatus {
            isPresented = false
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    VerifyAccountView(
        isPresented: .constant(true)
    )
    .environment(appSessionViewModel)
}
