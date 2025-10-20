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
            VStack(spacing: 0.0) {
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
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Create account")
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension CreateAccountScreenView {
    var accountInfoFormView: some View {
        VStack(spacing: 16.0) {
            InputTextFieldView(
                localizedTitle: "Email address",
                localizedPlaceholder: "Enter your email address",
                text: $createAccountViewModel.createAccountInfo.emailAddress,
                axis: .horizontal,
                lineLimit: 1
            )
            InputTextFieldView(
                localizedTitle: "Password",
                localizedPlaceholder: "Enter your password",
                text: $createAccountViewModel.createAccountInfo.password,
                isSecured: true
            )
            InputTextFieldView(
                localizedTitle: "Confirm Password",
                localizedPlaceholder: "Confirm password",
                text: $createAccountViewModel.createAccountInfo.confirmPassword,
                isSecured: true
            )
        }
    }
    var profileInfoFormView: some View {
        VStack(spacing: 16.0) {
            profilePhotoPickerView
            InputTextFieldView(
                localizedTitle: "Display name",
                localizedPlaceholder: "Enter your display name",
                text: $createAccountViewModel.createAccountInfo.displayName,
                axis: .horizontal,
                lineLimit: 1
            )
            InputTextFieldView(
                localizedTitle: "Username",
                localizedPlaceholder: "Enter your user name",
                text: $createAccountViewModel.createAccountInfo.username,
                axis: .horizontal,
                lineLimit: 1
            )
            birthdayPickerView
            InputTextFieldView(
                localizedTitle: "Bio",
                localizedPlaceholder: "Tell us a bit about yourself",
                text: $createAccountViewModel.createAccountInfo.bio,
                axis: .vertical,
                lineLimit: 5,
                height: 120.0
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
    }
    var buttonsRowView: some View {
        HStack(spacing: 12.0) {
            Button {
                withAnimation {
                    createAccountViewModel.currentCreateAccountSection = .accountInfo
                }
            } label: {
                Text("Back")
            }
            .secondaryFilledLargeButtonStyle()
            Button {
                Task { await signUpUser() }
            } label: {
                Text("Sign up")
            }
            .primaryFilledLargeButtonStyle()
        }
    }
}

private extension CreateAccountScreenView {
    func signUpUser() async {
        let result = await createAccountViewModel.signUpUser()
        if case .success = result {
            appSessionViewModel.changeAppSession(.authenticated)
        }
    }
}

#Preview {
    @Previewable @State var appSessionViewModel: AppSessionViewModel = .init()
    NavigationStack {
        CreateAccountScreenView()
    }
    .environment(appSessionViewModel)
}
