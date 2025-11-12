//
//  DataState.swift
//  MemoMap
//
//  Created by Dylan on 6/10/25.
//

import Foundation

enum DataState<T> {
    case initial
    case loading
    case success(T)
    case failure(String)
}
