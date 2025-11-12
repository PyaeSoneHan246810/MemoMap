//
//  Media.swift
//  MemoMap
//
//  Created by Dylan on 20/10/25.
//

import Foundation

struct Media: Identifiable {
    var type: MediaType
    var urlString: String
    var id: String {
        urlString
    }
}

enum MediaType {
    case video
    case image
}
