//
//  AddPinTip.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct AddPinTip: Tip {
    var id: String {
        "AddPinTip"
    }
    var title: Text {
        Text("Add Pin")
    }
    var message: Text? {
        Text("Add a new pin by tapping a location on the map.")
    }
    var image: Image? {
        Image(systemName: "plus")
    }
}
