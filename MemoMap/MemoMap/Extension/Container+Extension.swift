//
//  Container+Extension.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation
import Factory

extension Container {
    var authenticationRepository: Factory<AuthenticationRepository> {
        self {
            MainActor.assumeIsolated {
                FirebaseAuthenticationRepository()
            }
        }.singleton
    }
    var userProfileRepository: Factory<UserProfileRepository> {
        self {
            MainActor.assumeIsolated {
                FirebaseUserProfileRepository()
            }
        }.singleton
    }
    var storageRepository: Factory<StorageRepository> {
        self {
            MainActor.assumeIsolated {
                FirebaseStorageRepository()
            }
        }.singleton
    }
}
