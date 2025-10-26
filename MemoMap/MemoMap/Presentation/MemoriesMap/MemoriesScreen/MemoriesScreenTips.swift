//
//  MemoriesScreenTips.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct TapOnMapTip: Tip {
    var id: String {
        "TapOnMapTip"
    }
    var title: Text {
        Text("Tap On Map")
    }
    var message: Text? {
        Text("Tap on the map to save a location and memories.")
    }
    var image: Image? {
        Image(systemName: "map")
    }
}

struct LocateMeTip: Tip {
    var id: String {
        "LocateMeTip"
    }
    var title: Text {
        Text("Locate Me")
    }
    var message: Text? {
        Text("Tap here to find where you are on the map.")
    }
    var image: Image? {
        Image(systemName: "location")
    }
}

struct SettingsTip: Tip {
    var id: String {
        "SettingsTip"
    }
    var title: Text {
        Text("Settings")
    }
    var message: Text? {
        Text("Adjust your app preferences and account settings here.")
    }
    var image: Image? {
        Image(systemName: "gear")
    }
}
