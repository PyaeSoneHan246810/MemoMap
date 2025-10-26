//
//  MyProfileScreenTips.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct EditProfileTip: Tip {
    var id: String {
        "EditProfileTip"
    }
    var title: Text {
        Text("Edit Your Profile")
    }
    var message: Text? {
        Text("Keep your profile information up to date here.")
    }
    var image: Image? {
        Image(systemName: "pencil")
    }
}
