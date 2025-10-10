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
    
    func addMemoryHeart(memoryId: String, heartData: HeartData) async throws
    
    func removeMemeoryHeart(memoryId: String, userId: String) async throws
    
    func loadMemoryHearts(memoryId: String) async throws -> [HeartData]
    
    func checkIsHeartGiven(memoryId: String, userId: String) async throws -> Bool
    
    func listenCommentsCount(memoryId: String, completion: @escaping (Result<Int, Error>) -> Void)
    
    func listenHeartsCount(memoryId: String, completion: @escaping (Result<Int, Error>) -> Void)
    
    func loadFollowingsPublicMemories(followingIds: [String]) async throws -> [MemoryData]
}
