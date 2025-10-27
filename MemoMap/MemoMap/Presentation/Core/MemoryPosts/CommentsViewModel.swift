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
    
    var userData: UserData? {
        authenticationRepository.getUserData()
    }
    
    private(set) var userCommentsDataState: DataState<[UserComment]> = .loading
    
    var comment: String = ""
    
    private var trimmedComment: String {
        comment.trimmed()
    }
    
    private(set) var isAddCommentInProgress: Bool = false
    
    private(set) var addCommentError: AddMemoryCommentError? = nil
    
    var isAddCommentAlertPresented: Bool = false
    
    func addComment(memoryId: String) async {
        guard let userId = userData?.uid else {
            return
        }
        isAddCommentInProgress = true
        let commentData = CommentData(
            id: "",
            comment: trimmedComment,
            userId: userId,
            createdAt: .now
        )
        do {
            try await memoryRepository.addMemoryComment(memoryId: memoryId, commentData: commentData)
            await getUserComments(memoryId: memoryId)
            isAddCommentInProgress = false
            addCommentError = nil
            isAddCommentAlertPresented = false
            comment = ""
        } catch {
            isAddCommentInProgress = false
            if let addMemoryCommentError = error as? AddMemoryCommentError {
                self.addCommentError = addMemoryCommentError
            } else {
                self.addCommentError = .addFailed
            }
            isAddCommentAlertPresented = true
        }
    }
    
    func getUserComments(memoryId: String) async {
        userCommentsDataState = .loading
        do {
            let comments = try await memoryRepository.getMemoryComments(memoryId: memoryId)
            var userComments: [UserComment] = []
            for comment in comments {
                let userProfile = try? await userProfileRepository.getUserProfile(userId: comment.userId)
                let userComment = UserComment(comment: comment, userProfile: userProfile)
                userComments.append(userComment)
            }
            let sortedUserComments = userComments.sorted { lhs, rhs in
                lhs.comment.createdAt > rhs.comment.createdAt
            }
            userCommentsDataState = .success(sortedUserComments)
        } catch {
            if let getMemoryCommentsError = error as? GetMemoryCommentsError {
                let errorDescription = getMemoryCommentsError.localizedDescription
                userCommentsDataState = .failure(errorDescription)
            } else {
                let errorDescription = error.localizedDescription
                userCommentsDataState = .failure(errorDescription)
            }
        }
    }
}
