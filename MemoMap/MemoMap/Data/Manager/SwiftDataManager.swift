//
//  SwiftDataManager.swift
//  MemoMap
//
//  Created by Dylan on 13/10/25.
//

import Foundation
import SwiftData

final class SwiftDataManager {
    var container: ModelContainer?
    var context: ModelContext?
    
    init() {
        do {
            let configurations = ModelConfiguration(for: RecentUserSearch.self, RecentMemorySearch.self, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: RecentUserSearch.self, RecentMemorySearch.self, configurations: configurations)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
