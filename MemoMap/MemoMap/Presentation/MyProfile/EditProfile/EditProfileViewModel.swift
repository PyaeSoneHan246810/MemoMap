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
    
    var newBio: String = ""
    
    var newBirthday: Date = .now
    
    var newProfilePhotoPickerItem: PhotosPickerItem? = nil
    
    var newProfilePhotoImage: UIImage? = nil
    
    var newCoverPhotoPickerItem: PhotosPickerItem? = nil
    
    var newCoverPhotoImage: UIImage? = nil
    
    var existingProfilePhotoUrl: String? = nil
    
    var existingCoverPhotoUrl: String? = nil
    
    private var trimmedNewDisplayName: String {
        newDisplayName.trimmed()
    }
    
    private var trimmedNewBio: String {
        newBio.trimmed()
    }
    
    func getInitialData(userProfile: UserProfileData) {
        newDisplayName = userProfile.displayname
        newBio = userProfile.bio
        newBirthday = userProfile.birthday
        existingProfilePhotoUrl = userProfile.profilePhotoUrl
        existingCoverPhotoUrl = userProfile.coverPhotoUrl
    }
    
    func editProfile(for userId: String, onSuccess: () -> Void) async {
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
            onSuccess()
        } catch {
            if let updateUserProfileInfoError = error as? UpdateUserProfileInfoError {
                print(updateUserProfileInfoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    private func uploadProfilePhoto(userId: String) async -> String? {
        guard let newProfilePhotoImage, let data = newProfilePhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let profilePhotoUrl = try await storageRepository.uploadProfilePhoto(data: data, userId: userId)
            return profilePhotoUrl
        } catch {
            if let uploadProfilePhotoError = error as? UploadProfilePhotoError {
                print(uploadProfilePhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
    
    private func uploadCoverPhoto(userId: String) async -> String? {
        guard let newCoverPhotoImage, let data = newCoverPhotoImage.jpegData(compressionQuality: 1.0) else {
            return nil
        }
        do {
            let coverPhotoUrl = try await storageRepository.uploadCoverPhoto(data: data, userId: userId)
            return coverPhotoUrl
        } catch {
            if let uploadCoverPhotoError = error as? UploadCoverPhotoError {
                print(uploadCoverPhotoError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
            return nil
        }
    }
}
