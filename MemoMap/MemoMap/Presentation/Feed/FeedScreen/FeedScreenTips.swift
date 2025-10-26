//
//  FeedScreenTips.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct PostMemoryTip: Tip {
    var id: String {
        "PostMemoryTip"
    }
    var title: Text {
        Text("Post Your Memory")
    }
    var message: Text? {
        Text("Capture and share your favorite moments here.")
    }
    var image: Image? {
        Image(systemName: "square.and.pencil")
    }
}

struct SearchMemoriesTip: Tip {
    var id: String {
        "SearchMemoriesTip"
    }
    var title: Text {
        Text("Search Memories")
    }
    var message: Text? {
        Text("Discover public memories by searching a location here.")
    }
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}

struct CommunityTip: Tip {
    var id: String {
        "CommunityTip"
    }
    var title: Text {
        Text("Community")
    }
    var message: Text? {
        Text("See your followers, followings, and mutual connections here.")
    }
    var image: Image? {
        Image(systemName: "person.3")
    }
}
