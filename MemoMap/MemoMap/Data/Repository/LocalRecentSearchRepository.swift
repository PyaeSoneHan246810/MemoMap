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
    
    func saveRecentSearch(recentSearch: RecentSearch) {
        context?.insert(recentSearch)
        try? context?.save()
    }
    
    func deleteRecentSearch(recentSearch: RecentSearch) {
        context?.delete(recentSearch)
        try? context?.save()
    }
    
    func getRecentSearchesWithinOneWeek() -> [RecentSearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentSearch> = #Predicate { recentSearch in
            recentSearch.date >= oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentSearch> = .init(
            predicate: predicate,
            sortBy: [
                SortDescriptor(\.date, order: .reverse)
            ]
        )
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
    
    func deleteAllRecentSearches() {
        try? context?.delete(model: RecentSearch.self)
        try? context?.save()
    }
    
    func deleteRecentSearchesOlderThanOneWeek() {
        for recentSearch in getRecentSearchesOlderThanOneWeek() {
            context?.delete(recentSearch)
        }
        try? context?.save()
    }
    
    private func getRecentSearchesOlderThanOneWeek() -> [RecentSearch] {
        let oneWeekAgo = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? Date.distantPast
        let predicate: Predicate<RecentSearch> = #Predicate { recentSearch in
            recentSearch.date < oneWeekAgo
        }
        let fetchDescriptor: FetchDescriptor<RecentSearch> = .init(predicate: predicate)
        let recentSearches = try? context?.fetch(fetchDescriptor)
        return recentSearches ?? []
    }
}
