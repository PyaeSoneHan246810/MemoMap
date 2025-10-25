//
//  DeleteAccountScreenView.swift
//  MemoMap
//
//  Created by Dylan on 3/10/25.
//

import SwiftUI

struct DeleteAccountScreenView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppSessionViewModel.self) private var appSessionViewModel: AppSessionViewModel
    @State private var deleteAccountViewModel: DeleteAccountViewModel = .init()
    var body: some View {
        VStack(spacing: 0.0) {
            VStack(alignment: .leading, spacing: 20.0) {
                titleView
                descriptionView
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            VStack(spacing: 12.0) {
                deleteAccountButtonView
                goBackButtonView
            }
        }
        .padding(16.0)
        .navigationTitle("Delete account")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Delete account",
            isPresented: $deleteAccountViewModel.isDeleteAccountConfirmationPresented,
            actions: {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    Task {
                        await deleteAccount()
                    }
                }
            },
            message: {
                Text("Are you sure to delete this account?")
            }
        )
        .alert(
            isPresented: $deleteAccountViewModel.isDeleteAccountAlertPresented,
            error: deleteAccountViewModel.deleteAccountError
        ) {}
    }
}

private extension DeleteAccountScreenView {
    var titleView: some View {
        Text("Are your sure you want to delete your account?")
            .font(.title2)
            .fontWeight(.semibold)
    }
    var descriptionView: some View {
        Text("Once you delete your account, it cannot be undone. All your data will be permanently erased from this app.")
    }
    var deleteAccountButtonView: some View {
        Button {
            deleteAccountViewModel.isDeleteAccountConfirmationPresented = true
        } label: {
            Text("Delete account")
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: deleteAccountViewModel.isDeleteAccountInProgress)
        .tint(.red)
    }
    var goBackButtonView: some View {
        Button {
            dismiss()
        } label: {
            Text("Go back")
                .frame(maxWidth: .infinity)
        }
        .secondaryFilledLargeButtonStyle()
        .foregroundStyle(.primary)
    }
}

private extension DeleteAccountScreenView {
    func deleteAccount() async {
        await deleteAccountViewModel.deleteAccount(
            onSuccess: {
                appSessionViewModel.changeAppSession(.unauthenticated)
            }
        )
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        DeleteAccountScreenView()
    }
    .environment(appSessionViewModel)
}
