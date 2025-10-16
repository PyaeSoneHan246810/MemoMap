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
    
    @ObservationIgnored @Injected(\.recentSearchRepository) private var recentSearchRepository: RecentSearchRepository
    
    private(set) var searchUsersDataState: DataState<[UserProfileData]> = .initial
    
    private(set) var recentUserSearches: [RecentUserSearch] = []
    
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
        saveRecentUserSearch()
        searchUsersDataState = .loading
        do {
            let users = try await userRepository.searchUsersByUsernameOrDisplayName(name: trimmedSearchText)
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
    
    private func saveRecentUserSearch() {
        let recentUserSearch = RecentUserSearch(searchText: trimmedSearchText, date: .now)
        recentSearchRepository.saveRecentUserSearch(recentUserSearch)
    }
    
    func deleteRecentUserSearch(_ recentUserSearch: RecentUserSearch) {
        recentSearchRepository.deleteRecentUserSearch(recentUserSearch)
    }
    
    func getRecentUserSearches() {
        let recentUserSearches = recentSearchRepository.getRecentUserSearchesWithinOneWeek()
        self.recentUserSearches = recentUserSearches
    }
    
    func deleteAllRecentUserSearches() {
        recentSearchRepository.deleteAllRecentUserSearches()
    }
    
    func deleteRecentUserSearchesOlderThanOneWeek() {
        recentSearchRepository.deleteRecentUserSearchesOlderThanOneWeek()
    }
}
