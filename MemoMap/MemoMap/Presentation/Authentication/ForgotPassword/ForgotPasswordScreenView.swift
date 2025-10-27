//
//  ForgotPasswordScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI

struct ForgotPasswordScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ForgotPasswordViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                subtitleView
                Spacer().frame(height: 32.0)
                emailAddressTextFieldView
                Spacer().frame(height: 32.0)
                sendEmailButtonView
            }
            .padding(.horizontal, 16.0)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Forgot password?")
        .navigationBarTitleDisplayMode(.large)
        .alert(
            isPresented: $viewModel.isPasswordResetAlertPresented,
            error: viewModel.sendPasswordResetError
        ) {}
        .sheet(isPresented: $viewModel.isSuccessSheetPresented) {
            successSheetView
                .interactiveDismissDisabled()
        }
    }
}

private extension ForgotPasswordScreenView {
    var subtitleView: some View {
        Text("Don't worry. Please enter the email address associated with your account.")
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.callout)
            .foregroundStyle(.secondary)
    }
    var emailAddressTextFieldView: some View {
        InputTextFieldView(
            title: "Email address",
            placeholder: "Enter your email address",
            text: $viewModel.emailAddress,
            keyboardType: .emailAddress,
            textContentType: .emailAddress,
            autoCorrectionDisabled: true,
            submitLabel: .done
        )
    }
    var sendEmailButtonView: some View {
        Button {
            Task { await viewModel.sendPasswordReset() }
        } label: {
            Text("Send email")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isPasswordResetInProgress)
    }
    var successSheetView: some View {
        VStack {
            Spacer().frame(height: 160.0)
            sheetInfoView
            Spacer()
            sheetButtonsView
            Spacer().frame(height: 80.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 16.0)
    }
    var sheetInfoView: some View {
        VStack(spacing: 40.0) {
            Image(.checkEmail)
                .resizable()
                .scaledToFit()
                .frame(width: 160.0, height: 160.0)
                .foregroundStyle(.accent)
            VStack(spacing: 12.0) {
                Text("Check your email")
                    .font(.title)
                    .fontWeight(.bold)
                Text("The link to reset your password was successfully sent to the email address.")
                    .font(.callout)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
        }
    }
    var sheetButtonsView: some View {
        VStack(spacing: 12.0) {
            Button {
                dismiss()
            } label: {
                Text("Back to login")
                    .frame(maxWidth: .infinity)
            }
            .primaryFilledLargeButtonStyle()
            Button {
                viewModel.isSuccessSheetPresented = false
            } label: {
                Text("Retry")
                    .frame(maxWidth: .infinity)
            }
            .textLargeButtonStyle()
        }
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordScreenView()
    }
}
