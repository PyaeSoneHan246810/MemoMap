//
//  RecentSearchRepository.swift
//  MemoMap
//
//  Created by Dylan on 13/10/25.
//

protocol RecentSearchRepository {
    func saveRecentUserSearch(_ recentUserSearch: RecentUserSearch)
    
    func saveRecentMemorySearch(_ recentMemorySearch: RecentMemorySearch)
    
    func deleteRecentUserSearch(_ recentUserSearch: RecentUserSearch)
    
    func deleteRecentMemorySearch(_ recentMemorySearch: RecentMemorySearch)
    
    func getRecentUserSearchesWithinOneWeek() -> [RecentUserSearch]
    
    func getRecentMemorySearchesWithinOneWeek() -> [RecentMemorySearch]
    
    func deleteAllRecentUserSearches()
    
    func deleteAllRecentMemorySearches()
    
    func deleteRecentUserSearchesOlderThanOneWeek()
    
    func deleteRecentMemorySearchesOlderThanOneWeek()
}
