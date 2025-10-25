//
//  EditProfileView.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: EditProfileViewModel = .init()
    let userProfile: UserProfileData
    let onEdited: () -> Void
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16.0) {
                ZStack(alignment: .top) {
                    coverPhotoSelectionView
                    VStack(spacing: 16.0) {
                        profilePhotoSelectionView
                        displayNameInputView
                        bioInputView
                        birthdayPickerView
                        saveButtonView
                    }
                    .padding(.horizontal, 16.0)
                    .offset(y: 180.0)
                }
            }
        }
        .disableBouncesVertically()
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            toolbarContentView
        }
        .onAppear {
            viewModel.getInitialData(userProfile: userProfile)
        }
        .alert(
            isPresented: $viewModel.isEditProfileAlertPresented,
            error: viewModel.updateUserProfileInfoError
        ) {}
    }
}

private extension EditProfileView {
    @ToolbarContentBuilder
    var toolbarContentView: some ToolbarContent {
        ToolbarItem(placement: .navigation) {
            Button(role: .close) {
                dismiss()
            }
        }
    }
    var coverPhotoSelectionView: some View {
        ZStack(alignment: .bottomTrailing) {
            Rectangle()
                .frame(height: 240.0)
                .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                .overlay(alignment: .center) {
                    if let newCoverPhotoImage = viewModel.newCoverPhotoImage {
                        Image(uiImage: newCoverPhotoImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        if let coverPhotoUrl = userProfile.coverPhotoUrl {
                            KFImage(URL(string: coverPhotoUrl))
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(.imagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .frame(width: 100.0, height: 100.0)
                        }
                    }
                }
                .clipped()
            PhotosPicker(
                selection: $viewModel.newCoverPhotoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "pencil")
                    .imageScale(.large)
                    .tint(.primary)
                    .padding()
                    .glassEffect(.regular, in: .circle)
            }
            .padding(.bottom, 16.0)
            .padding(.trailing, 16.0)
            .onChange(of: viewModel.newCoverPhotoPickerItem) {
                Task {
                    let photoPickerItem = viewModel.newCoverPhotoPickerItem
                    if let coverPhotoData = try? await photoPickerItem?.loadTransferable(type: Data.self) {
                        let coverPhotoImage = UIImage(data: coverPhotoData)
                        viewModel.newCoverPhotoImage = coverPhotoImage
                    }
                }
            }
        }
    }
    var profilePhotoSelectionView: some View {
        ZStack(alignment: .bottomTrailing) {
            Group {
                if let newProfilePhotoImage = viewModel.newProfilePhotoImage {
                    Image(uiImage: newProfilePhotoImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120.0, height: 120.0)
                } else {
                    if let profilePhotoUrl = userProfile.profilePhotoUrl {
                        KFImage(URL(string: profilePhotoUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120.0, height: 120.0)
                    } else {
                        Image(.profilePlaceholder)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120.0, height: 120.0)
                            .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                            .background(Color(uiColor: .systemBackground))
                    }
                }
            }
            .clipShape(.circle)
            .overlay {
                Circle().stroke(Color(uiColor: .systemBackground), lineWidth: 2.0)
            }
            PhotosPicker(
                selection: $viewModel.newProfilePhotoPickerItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                Image(systemName: "pencil")
                    .imageScale(.large)
                    .tint(.primary)
                    .padding()
                    .glassEffect(.regular, in: .circle)
            }
            .offset(x: 12.0, y: 12.0)
            .onChange(of: viewModel.newProfilePhotoPickerItem) {
                Task {
                    let photoPickerItem = viewModel.newProfilePhotoPickerItem
                    if let profilePhotoData = try? await photoPickerItem?.loadTransferable(type: Data.self) {
                        let profilePhotoImage = UIImage(data: profilePhotoData)
                        viewModel.newProfilePhotoImage = profilePhotoImage
                    }
                }
            }
        }
    }
    var displayNameInputView: some View {
        InputTextFieldView(
            localizedTitle: "Display name",
            localizedPlaceholder: "Enter your display name",
            text: $viewModel.newDisplayName,
            keyboardType: .namePhonePad,
            textContentType: .username,
            autoCorrectionDisabled: true,
            submitLabel: .next
        )
    }
    var bioInputView: some View {
        InputTextFieldView(
            localizedTitle: "Bio",
            localizedPlaceholder: "Tell us a bit about yourself",
            text: $viewModel.newBio,
            autoCorrectionDisabled: true,
            submitLabel: .continue,
            axis: .vertical,
            lineLimit: 5
        )
    }
    var birthdayPickerView: some View {
        VStack(alignment: .leading, spacing: 12.0) {
            Text("Birthday")
                .font(.headline)
            DatePicker(
                "Pick your birthday",
                selection: $viewModel.newBirthday,
                displayedComponents: .date
            )
            .labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    var saveButtonView: some View {
        Button("Save") {
            Task {
                await viewModel.editProfile(
                    for: userProfile.id,
                    onSuccess: {
                        onEdited()
                        dismiss()
                    }
                )
            }
        }
        .primaryFilledLargeButtonStyle()
        .progressButtonStyle(isInProgress: viewModel.isEditProfileInProgress)
    }
}

#Preview {
    NavigationStack {
        EditProfileView(
            userProfile: UserProfileData.preview1,
            onEdited: {}
        )
    }
}
