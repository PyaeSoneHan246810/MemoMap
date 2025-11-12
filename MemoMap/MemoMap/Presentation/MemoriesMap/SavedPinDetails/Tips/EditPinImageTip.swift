//
//  EditPinImageTip.swift
//  MemoMap
//
//  Created by Dylan on 27/10/25.
//

import Foundation
import TipKit

struct EditPinImageTip: Tip {
    var id: String {
        "EditPinImageTip"
    }
    var title: Text {
        Text("Edit Pin Image")
    }
    var message: Text? {
        Text("Click here to change the pin image.")
    }
    var image: Image? {
        Image(systemName: "pencil")
    }
}
