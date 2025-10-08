//
//  MemoryData.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

struct MemoryData: Identifiable {
    let id: String
    let title: String
    let description: String?
    let media: [String]
    let tags: [String]
    let dateTime: Date
    let publicStatus: Bool
    let locationName: String
    let latitude: Double
    let longitude: Double
    let createdAt: Date
}

extension MemoryData {
    static let previews: [MemoryData] = [preview1, preview2]
    static let preview1: MemoryData = MemoryData(
        id: "1",
        title: "Bangkok Photo Dump",
        description: "Had a great time in Bangkok with friends",
        media: [],
        tags: [ "Friends", "FriendsTime", "Fun", "GoodTimes"],
        dateTime: .now,
        publicStatus: true,
        locationName: "Central World",
        latitude: 13.7465,
        longitude: 100.5391,
        createdAt: .now
    )
    static let preview2: MemoryData = MemoryData(
        id: "2",
        title: "Hanoi Photo Dump",
        description: "Had a great time in Hanoi with friends",
        media: [],
        tags: [ "Friends", "FriendsTime", "Fun", "GoodTimes"],
        dateTime: .now,
        publicStatus: false,
        locationName: "Lotte World Aquarium",
        latitude: 37.5135,
        longitude: 127.1049,
        createdAt: .now
    )
}
