//
//  ProfileViewModel.swift
//  MemoMap
//
//  Created by Dylan on 5/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class ProfileViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    private(set) var userProfileDataState: DataState<UserProfileData> = .initial
    
    var userProfileData: UserProfileData? {
        if case .success(let data) = userProfileDataState {
            return data
        } else {
            return nil
        }
    }
    
    func listenUserProfile() {
        self.userProfileDataState = .loading
        let userData = authenticationRepository.getUserData()
        userProfileRepository.listenUserProfile(userData: userData) { [weak self] result in
            switch result {
            case .success(let userProfileData):
                self?.userProfileDataState = .success(userProfileData)
            case .failure(let error):
                if let listenUserProfileError = error as? ListenUserProfileError {
                    print(listenUserProfileError.localizedDescription)
                    self?.userProfileDataState = .failure(listenUserProfileError.localizedDescription)
                } else {
                    print(error.localizedDescription)
                    self?.userProfileDataState = .failure(error.localizedDescription)
                }
            }
        }
    }
}
