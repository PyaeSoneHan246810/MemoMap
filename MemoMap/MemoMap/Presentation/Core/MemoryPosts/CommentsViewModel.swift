//
//  CommentsViewModel.swift
//  MemoMap
//
//  Created by Dylan on 9/10/25.
//

import Foundation
import Observation
import Factory

@Observable
final class CommentsViewModel {
    @ObservationIgnored @Injected(\.authenticationRepository) private var authenticationRepository: AuthenticationRepository
    
    @ObservationIgnored @Injected(\.memoryRepository) private var memoryRepository: MemoryRepository
    
    @ObservationIgnored @Injected(\.userProfileRepository) private var userProfileRepository: UserProfileRepository
    
    var comment: String = ""
    
    private(set) var userCommentsDataState: DataState<[UserComment]> = .loading
    
    private(set) var addCommentError: AddMemoryCommentError? = nil
    
    private var trimmedComment: String {
        comment.trimmed()
    }
    
    var userComments: [UserComment] {
        if case .success(let data) = userCommentsDataState {
            return data
        } else {
            return []
        }
    }
    
    func addComment(memoryId: String) async {
        guard let userId = authenticationRepository.getUserData()?.uid else {
            return
        }
        let commentData = CommentData(
            id: "",
            comment: trimmedComment,
            userId: userId,
            createdAt: .now
        )
        do {
            try await memoryRepository.addMemoryComment(memoryId: memoryId, commentData: commentData)
            comment = ""
            await getUserComments(memoryId: memoryId)
            await increaseCommentCount(memoryId: memoryId)
        } catch {
            if let addMemoryCommentError = error as? AddMemoryCommentError {
                print(addMemoryCommentError.localizedDescription)
                self.addCommentError = addMemoryCommentError
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func increaseCommentCount(memoryId: String) async {
        do {
            try await memoryRepository.increaseMemoryCommentsCount(memoryId: memoryId)
        } catch {
            if let updateMemoryCommentCountError = error as? UpdateMemoryCommentsCountError {
                print(updateMemoryCommentCountError.localizedDescription)
            } else {
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserComments(memoryId: String) async {
        userCommentsDataState = .loading
        do {
            let comments = try await memoryRepository.loadMemoryComments(memoryId: memoryId)
            var userComments: [UserComment] = []
            for comment in comments {
                let userProfile = try? await userProfileRepository.getUserProfile(userId: comment.userId)
                let userComment = UserComment(comment: comment, userProfile: userProfile)
                userComments.append(userComment)
            }
            userCommentsDataState = .success(userComments)
        } catch {
            if let loadMemoryCommentsError = error as? LoadMemoryCommentsError {
                let errorDescription = loadMemoryCommentsError.localizedDescription
                print(errorDescription)
                userCommentsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                print(errorDescription)
            }
        }
    }
}
