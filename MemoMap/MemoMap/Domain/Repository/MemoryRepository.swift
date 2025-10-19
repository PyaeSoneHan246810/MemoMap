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
    
    func getPinMemories(pinId: String) async throws -> [MemoryData]
    
    func addMemoryComment(memoryId: String, commentData: CommentData) async throws
    
    func getMemoryComments(memoryId: String) async throws -> [CommentData]
    
    func addMemoryHeart(memoryId: String, heartData: HeartData) async throws
    
    func removeMemeoryHeart(memoryId: String, userId: String) async throws
    
    func getMemoryHearts(memoryId: String) async throws -> [HeartData]
    
    func checkIsHeartGiven(memoryId: String, userId: String) async throws -> Bool
    
    func listenCommentsCount(memoryId: String, completion: @escaping (Result<Int, Error>) -> Void)
    
    func listenHeartsCount(memoryId: String, completion: @escaping (Result<Int, Error>) -> Void)
    
    func getFollowingsPublicMemories(followingIds: [String]) async throws -> [MemoryData]
    
    func getTotalHeartsCount(userData: UserData?) async throws -> Int
    
    func getTotoalHeartsCount(userId: String) async throws -> Int
    
    func getUserPublicMemories(userData: UserData?) async throws -> [MemoryData]
    
    func getUserPublicMemories(userId: String) async throws -> [MemoryData]
    
    func searchMemoriesByLocationName(locationName: String) async throws -> [MemoryData]
    
    func updateMemoriesPinInfo(pinId: String, pinName: String) async throws
    
    func deletePinMemories(pinId: String) async throws
    
    func deleteMemory(memoryId: String) async throws
    
    func updateMemoryInfo(memoryId: String, editMemoryInfo: EditMemoryInfo) async throws
    
    func getMemory(memoryId: String) async throws -> MemoryData
}
