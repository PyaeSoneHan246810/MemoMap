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
            let configurations = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(for: RecentSearch.self, configurations: configurations)
            if let container {
                context = ModelContext(container)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
