//
//  EditPinTip.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct EditPinTip: Tip {
    var id: String {
        "EditPinTip"
    }
    var title: Text {
        Text("Edit Pin")
    }
    var message: Text? {
        Text("Click here to edit pin name and description.")
    }
    var image: Image? {
        Image(systemName: "pencil")
    }
}
