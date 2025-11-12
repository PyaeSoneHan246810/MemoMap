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
    var pinRepository: Factory<PinRepository> {
        self {
            MainActor.assumeIsolated {
                FirebasePinRepository()
            }
        }.singleton
    }
    var memoryRepository: Factory<MemoryRepository> {
        self {
            MainActor.assumeIsolated {
                FirebaseMemoryRepository()
            }
        }.singleton
    }
    var userRepository: Factory<UserRepository> {
        self {
            MainActor.assumeIsolated {
                FirebaseUserRepository()
            }
        }.singleton
    }
    var swiftDataManager: Factory<SwiftDataManager> {
        self {
            MainActor.assumeIsolated {
                SwiftDataManager()
            }
        }.singleton
    }
    var recentSearchRepository: Factory<RecentSearchRepository> {
        self {
            MainActor.assumeIsolated {
                let swiftDataManager = self.swiftDataManager()
                return LocalRecentSearchRepository(context: swiftDataManager.context)
            }
        }.singleton
    }
}
