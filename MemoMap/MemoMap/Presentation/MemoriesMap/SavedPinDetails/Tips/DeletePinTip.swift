//
//  DeletePinTip.swift
//  MemoMap
//
//  Created by Dylan on 26/10/25.
//

import Foundation
import TipKit

struct DeletePinTip: Tip {
    var id: String {
        "DeletePinTip"
    }
    var title: Text {
        Text("Delete Pin")
    }
    var message: Text? {
        Text("Click here to delete this pin.")
    }
    var image: Image? {
        Image(systemName: "trash")
    }
}
