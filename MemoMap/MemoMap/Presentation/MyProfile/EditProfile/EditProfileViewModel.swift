//
//  EditProfileViewModel.swift
//  MemoMap
//
//  Created by Dylan on 17/10/25.
//

import SwiftUI
import Observation
import Factory
import PhotosUI

@Observable
final class EditProfileViewModel {
    @ObservationIgnored @Injected(\.storageRepository) private var storageRepository: StorageRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    var newDisplayName: String = ""
    
    private var trimmedNewDisplayName: String {
        newDisplayName.trimmed()
    }
    
    var newBio: String = ""
    
    private var trimmedNewBio: String {
        newBio.trimmed()
    }
    
    var newBirthday: Date = .now
    
    var newProfilePhotoPickerItem: PhotosPickerItem? = nil
    
    var newProfilePhotoImage: UIImage? = nil
    
    var newCoverPhotoPickerItem: PhotosPickerItem? = nil
    
    var newCoverPhotoImage: UIImage? = nil
    
    var existingProfilePhotoUrl: String? = nil
    
    var existingCoverPhotoUrl: String? = nil
    
    private(set) var isEditProfileInProgress: Bool = false
    
    private(set) var updateUserProfileInfoError: UpdateUserProfileInfoError? = nil
    
    var isEditProfileAlertPresented: Bool = false
    
    func getInitialData(userProfile: UserProfileData) {
        newDisplayName = userProfile.displayname
        newBio = userProfile.bio
        newBirthday = userProfile.birthday
        existingProfilePhotoUrl = userProfile.profilePhotoUrl
        existingCoverPhotoUrl = userProfile.coverPhotoUrl
    }
    
    func editProfile(for userId: String, onSuccess: () -> Void) async {
        isEditProfileInProgress = true
        let newProfilePhotoUrl = await uploadProfilePhoto(userId: userId) ?? existingProfilePhotoUrl
        let newCoverPhotoUrl = await uploadCoverPhoto(userId: userId) ?? existingCoverPhotoUrl
        let updateUserProfileData = UpdateUserProfileData(
            displayname: trimmedNewDisplayName,
            profilePhotoUrl: newProfilePhotoUrl,
            coverPhotoUrl: newCoverPhotoUrl,
            birthday: newBirthday,
            bio: trimmedNewBio
        )
        do {
            try await userProfileRepository.updateUserProfileInfo(userid: userId, updateUserProfileData: updateUserProfileData)
            isEditProfileInProgress = false
            updateUserProfileInfoError = nil
            isEditProfileAlertPresented = false
            onSuccess()
        } catch {
            isEditProfileInProgress = false
            if let updateUserProfileInfoError = error as? UpdateUserProfileInfoError {
                self.updateUserProfileInfoError = updateUserProfileInfoError
            } else {
                updateUserProfileInfoError = .unknownError
            }
            isEditProfileAlertPresented = true
        }
    }
    
    private func uploadProfilePhoto(userId: String) async -> String? {
        guard let newProfilePhotoImage, let data = newProfilePhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let profilePhotoUrl = try? await storageRepository.uploadProfilePhoto(data: data, userId: userId)
        return profilePhotoUrl
    }
    
    private func uploadCoverPhoto(userId: String) async -> String? {
        guard let newCoverPhotoImage, let data = newCoverPhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        let coverPhotoUrl = try? await storageRepository.uploadCoverPhoto(data: data, userId: userId)
        return coverPhotoUrl
    }
}
