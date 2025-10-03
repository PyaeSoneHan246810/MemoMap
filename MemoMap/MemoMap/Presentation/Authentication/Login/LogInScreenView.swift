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
            VStack(spacing: 0.0) {
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
    }
}

private extension LogInScreenView {
    var loginFormView: some View {
        VStack(spacing: 16.0) {
            InputTextFieldView(
                localizedTitle: "Email address",
                localizedPlaceholder: "Enter your email address",
                text: $loginViewModel.emailAddress,
                axis: .horizontal,
                lineLimit: 1
            )
            InputTextFieldView(
                localizedTitle: "Password",
                localizedPlaceholder: "Enter your password",
                text: $loginViewModel.password,
                isSecured: true
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
    var signInButtonView: some View {
        Button {
            Task { await signInUser() }
        } label: {
            Text("Sign in")
        }
        .primaryFilledLargeButtonStyle()
    }
}

private extension LogInScreenView {
    func signInUser() async {
        let result = await loginViewModel.signInUser()
        if case .success = result {
            appSessionViewModel.changeAppSession(.authenticated)
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        LogInScreenView()
    }
    .environment(appSessionViewModel)
}
