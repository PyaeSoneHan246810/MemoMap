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
    
    private(set) var recentSearches: [RecentSearch] = []
    
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
        saveRecentSearch()
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
    
    private func saveRecentSearch() {
        let recentSearch = RecentSearch(searchText: trimmedSearchText, date: .now)
        recentSearchRepository.saveRecentSearch(recentSearch: recentSearch)
    }
    
    func deleteRecentSearch(_ recentSearch: RecentSearch) {
        recentSearchRepository.deleteRecentSearch(recentSearch: recentSearch)
    }
    
    func getRecentSearches() {
        let recentSearches = recentSearchRepository.getRecentSearchesWithinOneWeek()
        self.recentSearches = recentSearches
    }
    
    func deleteAllRecentSearches() {
        recentSearchRepository.deleteAllRecentSearches()
    }
    
    func deleteRecentSearchesOlderThanOneWeek() {
        recentSearchRepository.deleteRecentSearchesOlderThanOneWeek()
    }
}
