//
//  MemoryPost.swift
//  MemoMap
//
//  Created by Dylan on 8/10/25.
//

import Foundation

struct MemoryPost: Identifiable {
    let memory: MemoryData
    let userProfile: UserProfileData?
    var id: String {
        memory.id
    }
}
