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
    
    func listenPins(userData: UserData?, completion: @escaping (Result<[PinData], Error>) -> Void)
    
    func getPin(pinId: String) async throws -> PinData
    
    func updatePinInfo(pinId: String, pinName: String, pinDescription: String?) async throws
}
