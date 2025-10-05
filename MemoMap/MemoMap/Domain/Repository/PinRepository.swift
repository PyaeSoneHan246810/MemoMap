//
//  PinRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

protocol PinRepository {
    func savePin(pinData: PinData, userData: UserData?) async throws -> String
    
    func updatePinPhotoUrl(pinId: String, pinPhotoUrlString: String) async throws
    
    func deletePin(pinId: String) async throws
}
