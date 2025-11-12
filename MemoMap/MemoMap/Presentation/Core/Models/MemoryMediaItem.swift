//
//  MemoryMediaItem.swift
//  MemoMap
//
//  Created by Dylan on 8/10/25.
//

import Foundation

struct MemoryMediaItem: Identifiable, Equatable {
    let id: UUID = UUID()
    let media: MemoryMedia
    static func == (lhs: MemoryMediaItem, rhs: MemoryMediaItem) -> Bool {
        lhs.id == rhs.id
    }
}
