//
//  SearchMemoriesViewModel.swift
//  MemoMap
//
//  Created by Dylan on 15/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class SearchMemoriesViewModel {
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.recentSearchRepository) private var recentSearchRepository: RecentSearchRepository
    
    private(set) var searchMemoriesDataState: DataState<[MemoryData]> = .initial
    
    private(set) var recentMemorySearches: [RecentMemorySearch] = []
    
    var searchText: String = ""
    
    var trimmedSearchText: String {
        searchText.trimmed()
    }
    
    func clearSearchText() {
        searchText = ""
    }
    
    func resetSearchState() {
        searchMemoriesDataState = .initial
    }
    
    func searchMemories() async {
        saveRecentMemorySearch()
        searchMemoriesDataState = .loading
        do {
            let memories = try await memoryRepository.searchMemoriesByLocationName(locationName: trimmedSearchText)
            searchMemoriesDataState = .success(memories)
        } catch {
            if let searchMemoriesError = error as? SearchMemoriesError {
                let errorDescription = searchMemoriesError.localizedDescription
                searchMemoriesDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                searchMemoriesDataState = .failure(errorDescription)
            }
        }
    }
    
    private func saveRecentMemorySearch() {
        let recentMemorySearch = RecentMemorySearch(searchText: trimmedSearchText, date: .now)
        recentSearchRepository.saveRecentMemorySearch(recentMemorySearch)
    }
    
    func deleteRecentMemorySearch(_ recentMemorySearch: RecentMemorySearch) {
        recentSearchRepository.deleteRecentMemorySearch(recentMemorySearch)
    }
    
    func getRecentMemorySearches() {
        let recentMemorySearches = recentSearchRepository.getRecentMemorySearchesWithinOneWeek()
        self.recentMemorySearches = recentMemorySearches
    }
    
    func deleteAllRecentMemorySearches() {
        recentSearchRepository.deleteAllRecentMemorySearches()
    }
    
    func deleteRecentMemorySearchesOlderThanOneWeek() {
        recentSearchRepository.deleteRecentMemorySearchesOlderThanOneWeek()
    }
}
