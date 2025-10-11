//
//  SearchUsersViewModel.swift
//  MemoMap
//
//  Created by Dylan on 11/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class SearchUsersViewModel {
    
    @ObservationIgnored @Injected(\.userRepository) private var userRepository: UserRepository
    
    
    private(set) var searchUsersDataState: DataState<[UserProfileData]> = .initial
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
    }
    
    func clearSearchText() {
        searchText = ""
    }
    
    func resetSearchState() {
        searchUsersDataState = .initial
    }
    
    func searchUsers() async {
        searchUsersDataState = .loading
        do {
            let users = try await userRepository.searchUsers(searchText: trimmedSearchText)
            searchUsersDataState = .success(users)
        } catch {
            if let searchUserError = error as? SearchUsersError {
                let errorDescription = searchUserError.localizedDescription
                print(errorDescription)
                searchUsersDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
                searchUsersDataState = .failure(errorDescription)
            }
        }
    }
}
