//
//  SearchUsersTIp.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import TipKit

struct SearchUsersTip: Tip {
    var id: String {
        "SearchUsersTip"
    }
    var title: Text {
        Text("Search Users")
    }
    var message: Text? {
        Text("Search for other users by entering a username or display name here.")
    }
    var image: Image? {
        Image(systemName: "magnifyingglass")
    }
}
