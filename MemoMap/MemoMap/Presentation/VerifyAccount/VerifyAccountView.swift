//
//  VerifyAccountView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct VerifyAccountView: View {
    @Binding var isPresented: Bool
    @State private var viewModel: VerifyAccountViewModel = .init()
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
                Task { await checkEmailVerificationStatus() }
            } label: {
                Text("I've verified")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
            Button {
                Task { await viewModel.sendEmailVerification() }
            } label: {
                Text("Resend verification link")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderless)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
        }
    }
}

private extension VerifyAccountView {
    func checkEmailVerificationStatus() async {
        let emailVerificationStatus = await viewModel.checkEmailVerificationStatus()
        if case .verified = emailVerificationStatus {
            isPresented = false
        }
    }
}

#Preview {
    VerifyAccountView(
        isPresented: .constant(true)
    )
}
