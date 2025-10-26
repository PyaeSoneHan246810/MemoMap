//
//  SelectPinTip.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct SelectPinTip: Tip {
    var id: String {
        "SelectPinTip"
    }
    var title: Text {
        Text("Select Pin")
    }
    var message: Text? {
        Text("Click here to select this location.")
    }
}
