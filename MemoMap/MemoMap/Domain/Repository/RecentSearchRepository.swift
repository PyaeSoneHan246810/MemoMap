//
//  RecentSearchRepository.swift
//  MemoMap
//
//  Created by Dylan on 13/10/25.
//

protocol RecentSearchRepository {
    func saveRecentSearch(recentSearch: RecentSearch)
    
    func deleteRecentSearch(recentSearch: RecentSearch)
    
    func getRecentSearchesWithinOneWeek() -> [RecentSearch]
    
    func deleteAllRecentSearches()
    
    func deleteRecentSearchesOlderThanOneWeek()
}
