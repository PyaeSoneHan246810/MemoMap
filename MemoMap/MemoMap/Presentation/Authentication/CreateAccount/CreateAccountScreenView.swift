//
//  CreateAccountScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import PhotosUI

struct CreateAccountScreenView: View {
    @Environment(AppSessionViewModel.self) private var appSessionViewModel
    @State private var createAccountViewModel: CreateAccountViewModel = .init()
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0.0) {
                Spacer().frame(height: 32.0)
                switch createAccountViewModel.currentCreateAccountSection {
                case .accountInfo:
                    accountInfoFormView
                case .profileInfo:
                    profileInfoFormView
                }
                Spacer().frame(height: 32.0)
                switch createAccountViewModel.currentCreateAccountSection {
                case .accountInfo:
                    nextButtonView
                case .profileInfo:
                    buttonsRowView
                }
            }
            .padding(.horizontal, 16.0)
            .animation(.smooth, value: createAccountViewModel.showInvalidEmailMessage)
            .animation(.smooth, value: createAccountViewModel.showPasswordValidationMessages)
            .animation(.smooth, value: createAccountViewModel.showPasswordMismatchMessage)
            .animation(.smooth, value: createAccountViewModel.showUsernameValidationMessage)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Create account")
        .navigationBarTitleDisplayMode(.large)
        .alert(
            isPresented: $createAccountViewModel.isSignUpUserAlertPresented,
            error: createAccountViewModel.signUpUserError
        ) {}
    }
}

private extension CreateAccountScreenView {
    var accountInfoFormView: some View {
        VStack(spacing: 16.0) {
            VStack(alignment: .leading, spacing: 8.0) {
                InputTextFieldView(
                    title: "Email address",
                    placeholder: "Enter your email address",
                    text: $createAccountViewModel.createAccountInfo.emailAddress,
                    keyboardType: .emailAddress,
                    textContentType: .emailAddress,
                    autoCorrectionDisabled: true,
                    submitLabel: .next
                )
                if createAccountViewModel.showInvalidEmailMessage {
                    invalidEmailMessageView
                }
            }
            VStack(alignment: .leading, spacing: 8.0) {
                InputTextFieldView(
                    title: "Password",
                    placeholder: "Enter your password",
                    text: $createAccountViewModel.createAccountInfo.password,
                    isSecured: true,
                    textContentType: .newPassword,
                    autoCorrectionDisabled: true,
                    submitLabel: .next
                )
                if createAccountViewModel.showPasswordValidationMessages {
                    passwordValidationMessagesView
                }
            }
            VStack(alignment: .leading, spacing: 8.0) {
                InputTextFieldView(
                    title: "Confirm Password",
                    placeholder: "Confirm your password",
                    text: $createAccountViewModel.createAccountInfo.confirmPassword,
                    isSecured: true,
                    textContentType: .newPassword,
                    autoCorrectionDisabled: true,
                    submitLabel: .continue
                )
                if createAccountViewModel.showPasswordMismatchMessage {
                    passwordMismatchMessageView
                }
            }
        }
    }
    var invalidEmailMessageView: some View {
        Text("Plase enter a valid email address.")
            .font(.callout)
            .foregroundStyle(.red)
    }
    var passwordValidationMessagesView: some View {
        VStack(alignment: .leading, spacing: 4.0) {
            passwordValidationMessageView(
                isValid: createAccountViewModel.passwordHasEightCharsOrMore,
                message: "8 characters or more"
            )
            passwordValidationMessageView(
                isValid: createAccountViewModel.passwordHasAtLeastOneUppercaseChar,
                message: "At least one uppercase character"
            )
            passwordValidationMessageView(
                isValid: createAccountViewModel.passwordHasAtLeastOneLowercaseChar,
                message: "At least one lowercase character"
            )
            passwordValidationMessageView(
                isValid: createAccountViewModel.passwordHasAtLeastOneNumericChar,
                message: "At least one numeric character"
            )
            passwordValidationMessageView(
                isValid: createAccountViewModel.passwordHasAtLeastOneSpecialChar,
                message: "At least one special character"
            )
        }
    }
    var passwordMismatchMessageView: some View {
        Text("Passwords do not match.")
            .font(.callout)
            .foregroundStyle(.red)
    }
    func passwordValidationMessageView(isValid: Bool, message: String) -> some View {
        HStack {
            Image(systemName: isValid ? "checkmark.square" : "square")
                .foregroundStyle(isValid ? .accent : .secondary)
                .animation(.smooth, value: isValid)
            Text(message)
                .font(.callout)
                .foregroundStyle(.primary.opacity(0.8))
        }
    }
    var profileInfoFormView: some View {
        VStack(spacing: 16.0) {
            profilePhotoPickerView
            InputTextFieldView(
                title: "Display name",
                placeholder: "Enter your display name",
                text: $createAccountViewModel.createAccountInfo.displayName,
                keyboardType: .namePhonePad,
                textContentType: .username,
                autoCorrectionDisabled: true,
                submitLabel: .next
            )
            VStack(alignment: .leading, spacing: 8.0) {
                InputTextFieldView(
                    title: "Username",
                    placeholder: "Enter your username",
                    text: $createAccountViewModel.createAccountInfo.username,
                    keyboardType: .namePhonePad,
                    textContentType: .username,
                    autoCorrectionDisabled: true,
                    submitLabel: .next
                )
                .onChange(of: createAccountViewModel.createAccountInfo.username) {
                    createAccountViewModel.normalizeUsername()
                }
                Text("Username can only contain letters, numbers, and underscores.")
                    .font(.callout)
                    .foregroundStyle(.primary.opacity(0.8))
                if createAccountViewModel.showUsernameValidationMessage {
                    Text("Username must be 5 to 20 characters long.")
                        .font(.callout)
                        .foregroundStyle(.red)
                }
            }
            birthdayPickerView
            InputTextFieldView(
                title: "Bio",
                placeholder: "Tell us a bit about yourself",
                text: $createAccountViewModel.createAccountInfo.bio,
                submitLabel: .done,
                axis: .vertical,
                lineLimit: 5,
            )
        }
    }
    var profilePhotoPickerView: some View {
        PhotosPicker(
            selection: $createAccountViewModel.createAccountInfo.profilePhotoPickerItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            ZStack(alignment: .bottomTrailing) {
                if let profilePhotoImage = createAccountViewModel.createAccountInfo.profilePhotoImage {
                    Image(uiImage: profilePhotoImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140.0, height: 140.0)
                        .clipShape(.circle)
                } else {
                    Image(.profilePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140.0, height: 140.0)
                        .tint(Color(uiColor: .secondarySystemBackground))
                }
                Image(systemName: "pencil")
                    .imageScale(.large)
                    .tint(.primary)
                    .padding()
                    .glassEffect(.regular, in: .circle)
                    .offset(x: 12.0, y: 12.0)
            }
        }
        .onChange(of: createAccountViewModel.createAccountInfo.profilePhotoPickerItem) {
            Task {
                let photoPickerItem = createAccountViewModel.createAccountInfo.profilePhotoPickerItem
                if let profilePhotoData = try? await photoPickerItem?.loadTransferable(type: Data.self) {
                    let profilePhotoImage = UIImage(data: profilePhotoData)
                    createAccountViewModel.createAccountInfo.profilePhotoImage = profilePhotoImage
                }
            }
        }
    }
    var birthdayPickerView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text("Birthday")
                .font(.headline)
            DatePicker(
                "Pick your birthday",
                selection: $createAccountViewModel.createAccountInfo.birthday,
                in: ...Date(),
                displayedComponents: .date
            )
            .labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var nextButtonView: some View {
        Button {
            withAnimation {
                createAccountViewModel.currentCreateAccountSection = .profileInfo
            }
        } label: {
            Text("Next")
        }
        .primaryFilledLargeButtonStyle()
        .disabled(!createAccountViewModel.areCredentialsValid)
    }
    var buttonsRowView: some View {
        VStack(spacing: 12.0) {
            Button {
                Task { await signUpUser() }
            } label: {
                Text("Sign up")
            }
            .primaryFilledLargeButtonStyle()
            .progressButtonStyle(isInProgress: createAccountViewModel.isSignUpUserInProgress)
            .disabled(!createAccountViewModel.isProfileInfoValid)
            Button {
                withAnimation {
                    createAccountViewModel.currentCreateAccountSection = .accountInfo
                }
            } label: {
                Text("Back")
            }
            .secondaryFilledLargeButtonStyle()
        }
    }
}

private extension CreateAccountScreenView {
    func signUpUser() async {
        await createAccountViewModel.signUpUser(
            onSuccess: {
                appSessionViewModel.changeAppSession(.authenticated)
            }
        )
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        CreateAccountScreenView()
    }
    .environment(appSessionViewModel)
}
