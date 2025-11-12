//
//  PinData.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

struct PinData: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String?
    let photoUrl: String?
    let latitude: Double
    let longitude: Double
    let createdAt: Date
}

extension PinData {
    static let preview1: PinData = PinData(
        id: "1",
        name: "Central World",
        description: "A shopping plaza and complex in the Siam area of Bangkok, in Thailand. It is the ninth-largest shopping center in the world.",
        photoUrl: "https://www.centralworld.co.th/storage/about-us/img-01.jpg",
        latitude: 13.7465,
        longitude: 100.5391,
        createdAt: .now
    )
}
