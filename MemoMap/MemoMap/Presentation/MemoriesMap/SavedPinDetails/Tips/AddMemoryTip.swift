//
//  AddMemoryTip.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct AddMemoryTip: Tip {
    var id: String {
        "AddMemoryTip"
    }
    var title: Text {
        Text("Add Memory")
    }
    var message: Text? {
        Text("Click here to add a new memory.")
    }
    var image: Image? {
        Image(systemName: "plus")
    }
}
