//
//  MemoryMedia.swift
//  MemoMap
//
//  Created by Dylan on 28/9/25.
//

import SwiftUI

enum MemoryMedia: Identifiable {
    case image(id: UUID, UIImage)
    case video(id: UUID, Movie)
    var id: UUID {
        switch self {
        case .image(let id, _):
            id
        case .video(let id, _):
            id
        }
    }
}
