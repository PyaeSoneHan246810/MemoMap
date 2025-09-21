//
//  LogInScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct LogInScreenView: View {
    @State private var emailAddress: String = ""
    @State private var password: String = ""
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
                title: "Email address",
                placeholder: "Enter your email address",
                text: $emailAddress
            )
            InputTextFieldView(
                title: "Password",
                placeholder: "Enter your password",
                text: $password,
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
            
        } label: {
            Text("Sign in")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8.0))
        .controlSize(.large)
    }
}

#Preview {
    NavigationStack {
        LogInScreenView()
    }
}
