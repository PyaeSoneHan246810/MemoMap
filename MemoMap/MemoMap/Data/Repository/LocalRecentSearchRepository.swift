//
//  LocalRecentSearchRepository.swift
//  MemoMap
//
//  Created by Dylan on 13/10/25.
//

import Foundation
import SwiftData

@MainActor
final class LocalRecentSearchRepository: RecentSearchRepository {
    
    private let context: ModelContext?
    
    init(context: ModelContext?) {
        self.context = context
    }
    
    func saveRecentUserSearch(_ recentUserSearch: RecentUserSearch) {
        context?.insert(recentUserSearch)
        try? context?.save()
    }
    
    func saveRecentMemorySearch(_ recentMemorySearch: RecentMemorySearch) {
        context?.insert(recentMemorySearch)
        try? context?.save()
    }
    
    func deleteRecentUserSearch(_ recentUserSearch: RecentUserSearch) {
        context?.delete(recentUserSearch)
        try? context?.save()
    }
    
    func deleteRecentMemorySearch(_ recentMemorySearch: RecentMemorySearch) {
        context?.delete(recentMemorySearch)
        try? context?.save()
    }
    
    func getRecentUserSearchesWithinOneWeek() -> [RecentUserSearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentUserSearch> = #Predicate { recentSearch in
            recentSearch.date >= oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentUserSearch> = .init(
            predicate: predicate,
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
    
    func getRecentMemorySearchesWithinOneWeek() -> [RecentMemorySearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentMemorySearch> = #Predicate { recentSearch in
            recentSearch.date >= oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentMemorySearch> = .init(
            predicate: predicate,
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
    
    func deleteAllRecentUserSearches() {
        try? context?.delete(model: RecentUserSearch.self)
        try? context?.save()
    }
    
    func deleteAllRecentMemorySearches() {
        try? context?.delete(model: RecentMemorySearch.self)
        try? context?.save()
    }
    
    func deleteRecentUserSearchesOlderThanOneWeek() {
        for recentSearch in getRecentUserSearchesOlderThanOneWeek() {
            context?.delete(recentSearch)
        }
        try? context?.save()
    }
    
    func deleteRecentMemorySearchesOlderThanOneWeek() {
        for recentSearch in getRecentMemorySearchesOlderThanOneWeek() {
            context?.delete(recentSearch)
        }
        try? context?.save()
    }
    
    private func getRecentUserSearchesOlderThanOneWeek() -> [RecentUserSearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentUserSearch> = #Predicate { recentSearch in
            recentSearch.date < oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentUserSearch> = .init(predicate: predicate)
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
    
    private func getRecentMemorySearchesOlderThanOneWeek() -> [RecentMemorySearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentMemorySearch> = #Predicate { recentSearch in
            recentSearch.date < oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentMemorySearch> = .init(predicate: predicate)
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
}
