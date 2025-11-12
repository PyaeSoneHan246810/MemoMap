//
//  String+Extension.swift
//  MemoMap
//
//  Created by Dylan on 30/9/25.
//

import Foundation

extension String {
    func trimmed() -> String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
