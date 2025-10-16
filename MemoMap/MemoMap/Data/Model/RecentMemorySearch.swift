//
//  RecentMemorySearch.swift
//  MemoMap
//
//  Created by Dylan on 16/10/25.
//

import Foundation
import SwiftData

@Model
class RecentMemorySearch {
    var searchText: String
    var date: Date
    init(searchText: String, date: Date) {
        self.searchText = searchText
        self.date = date
    }
}
