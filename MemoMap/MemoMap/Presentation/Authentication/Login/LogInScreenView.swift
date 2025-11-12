//
//  LogInScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct LogInScreenView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel
    @State private var loginViewModel: LoginViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                Spacer().frame(height: 32.0)
                loginFormView
                Spacer().frame(height: 32.0)
                signInButtonView
            }
            .padding(.horizontal, 16.0)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Log in")
        .navigationBarTitleDisplayMode(.large)
        .alert(
            isPresented: $loginViewModel.isSignInUserAlertPresented,
            error: loginViewModel.signInUserError
        ) {}
    }
}

private extension LogInScreenView {
    var loginFormView: some View {
        VStack(spacing: 16.0) {
            InputTextFieldView(
                title: "Email address",
                placeholder: "Enter your email address",
                text: $loginViewModel.emailAddress,
                keyboardType: .emailAddress,
                textContentType: .emailAddress,
                autoCorrectionDisabled: true,
                submitLabel: .next
            )
            InputTextFieldView(
                title: "Password",
                placeholder: "Enter your password",
                text: $loginViewModel.password,
                isSecured: true,
                textContentType: .password,
                autoCorrectionDisabled: true,
                submitLabel: .done
            )
            forgotPasswordLinkView
        }
    }
    var forgotPasswordLinkView: some View {
        HStack {
            Spacer()
            NavigationLink {
                ForgotPasswordScreenView()
            } label: {
                Text("Forgot password?")
                    .font(.callout)
                    .fontWeight(.medium)
            }
            .tint(.primary)
        }
    }
    @ViewBuilder
    var signInButtonView: some View {
        Button {
            Task { await signInUser() }
        } label: {
            Text("Sign in")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: loginViewModel.isSignInUserInProgress)
        .disabled(!loginViewModel.isSignInValid)
    }
}

private extension LogInScreenView {
    func signInUser() async {
        await loginViewModel.signInUser(
            onSuccess: {
                appSessionViewModel.changeAppSession(.authenticated)
            }
        )
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        LogInScreenView()
    }
    .environment(appSessionViewModel)
}
