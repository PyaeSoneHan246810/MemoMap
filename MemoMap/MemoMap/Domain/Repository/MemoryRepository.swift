//
//  MemoryRepository.swift
//  MemoMap
//
//  Created by Dylan on 4/10/25.
//

import Foundation

protocol MemoryRepository {
    func saveMemory(memoryData: MemoryData, pinId: String, userData: UserData?) async throws -> String
    
    func updateMemoryMedia(memoryId: String, media: [String]) async throws
    
    func listenPinMemories(pinId: String, completion: @escaping (Result<[MemoryData], Error>) -> Void)
    
    func listenUserPublicMemories(userData: UserData?, completion: @escaping (Result<[MemoryData], Error>) -> Void)
}
