//
//  PostCommentRepliesInteractor.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

protocol PostCommentRepliesBusinessLogic {
    func showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request)
    func showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request)
}

protocol PostCommentRepliesDataStore {
    var replies: [PostComment] { get set }
    var parentComment: PostComment? { get set }
    var postID: Int { get set }
}

final class PostCommentRepliesInteractor: PostCommentRepliesBusinessLogic, PostCommentRepliesDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostCommentRepliesPresentationLogic?
    var worker: PostCommentRepliesWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var replies: [PostComment] = []
    var parentComment: PostComment?
    var postID: Int = 0
    
    // MARK: - Business Logic
    
    func showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request) {
        if request.isReload {
            worker?.fetchReplies(id: replies.first?.id ?? 0, completion: { [weak self] (response, error) in
                guard let self = self else { return }
                guard let parentComment = self.replies.first else { return }
                self.parentComment = parentComment
                self.replies = response ?? []
                self.replies.remove(at: 0)
                self.presenter?.presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response())
            })
        } else {
            guard let parentComment = self.replies.first else { return }
            self.parentComment = parentComment
            
            self.presenter?.presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response())
        }
        
    }
    
    func showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request) {
        worker?.createComment(content: request.content, post: postID, parent: replies.first?.id ?? 0, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            
            self.presenter?.presentSubmitCommentResult(response: PostCommentRepliesModels.SubmitComment.Response(error: error))
        })
    }
    
}
