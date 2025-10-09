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
    
    func addMemoryComment(memoryId: String, commentData: CommentData) async throws
    
    func loadMemoryComments(memoryId: String) async throws -> [CommentData]
    
    func increaseMemoryCommentsCount(memoryId: String) async throws
    
    func addMemoryHeart(memoryId: String, heartData: HeartData) async throws
    
    func increaseMemoryHeartsCount(memoryId: String) async throws
    
    func removeMemeoryHeart(memoryId: String, userId: String) async throws
    
    func decreaseMemoryHeartsCount(memoryId: String) async throws
    
    func checkIsHeartGiven(memoryId: String, userId: String) async throws -> Bool
}
