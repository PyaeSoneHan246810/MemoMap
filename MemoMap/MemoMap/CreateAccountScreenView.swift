//
//  CreateAccountScreenView.swift
//  MemoMap
//
//  Created by Dylan on 21/9/25.
//

import SwiftUI
import PhotosUI

enum CreateAccountSection {
    case accountInfo
    case profileInfo
}

struct CreateAccountInfo {
    var emailAddress: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var profilePhotoPickerItem: PhotosPickerItem? = nil
    var profilePhotoImage: Image? = nil
    var displayName: String = ""
    var username: String = ""
    var birthday: Date = .now
    var bio: String = ""
}

struct CreateAccountScreenView: View {
    @State private var currentCreateAccountSection: CreateAccountSection = .accountInfo
    @State private var createAccountInfo: CreateAccountInfo = .init()
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0.0) {
                Spacer().frame(height: 32.0)
                switch currentCreateAccountSection {
                case .accountInfo:
                    accountInfoFormView
                case .profileInfo:
                    profileInfoFormView
                }
                Spacer().frame(height: 32.0)
                switch currentCreateAccountSection {
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
                title: "Email address",
                placeholder: "Enter your email address",
                text: $createAccountInfo.emailAddress
            )
            InputTextFieldView(
                title: "Password",
                placeholder: "Enter your password",
                text: $createAccountInfo.password,
                isSecured: true
            )
            InputTextFieldView(
                title: "Confirm Password",
                placeholder: "Confirm password",
                text: $createAccountInfo.confirmPassword,
                isSecured: true
            )
        }
    }
    var profileInfoFormView: some View {
        VStack(spacing: 16.0) {
            profilePhotoPickerView
            InputTextFieldView(
                title: "Display name",
                placeholder: "Enter your display name",
                text: $createAccountInfo.displayName
            )
            InputTextFieldView(
                title: "Username",
                placeholder: "Enter your user name",
                text: $createAccountInfo.username
            )
            birthdayPickerView
            InputTextFieldView(
                title: "Bio",
                placeholder: "Tell us a bit about yourself",
                text: $createAccountInfo.bio,
                lineLimit: 5,
                height: 120.0
            )
        }
    }
    var profilePhotoPickerView: some View {
        PhotosPicker(
            selection: $createAccountInfo.profilePhotoPickerItem,
            matching: .images
        ) {
            ZStack(alignment: .bottomTrailing) {
                if let profilePhoto = createAccountInfo.profilePhotoImage {
                    profilePhoto
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
        .onChange(of: createAccountInfo.profilePhotoPickerItem) {
            Task {
                if let profilePhotoImage = try? await createAccountInfo.profilePhotoPickerItem?.loadTransferable(type: Image.self) {
                    createAccountInfo.profilePhotoImage = profilePhotoImage
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
                selection: $createAccountInfo.birthday,
                displayedComponents: .date
            )
            .labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var nextButtonView: some View {
        Button {
            withAnimation {
                currentCreateAccountSection = .profileInfo
            }
        } label: {
            Text("Next")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.roundedRectangle(radius: 8.0))
        .controlSize(.large)
    }
    var buttonsRowView: some View {
        HStack(spacing: 12.0) {
            Button {
                withAnimation {
                    currentCreateAccountSection = .accountInfo
                }
            } label: {
                Text("Back")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
            Button {

            } label: {
                Text("Sign up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 8.0))
            .controlSize(.large)
        }
    }
}

#Preview {
    NavigationStack {
        CreateAccountScreenView()
    }
}
