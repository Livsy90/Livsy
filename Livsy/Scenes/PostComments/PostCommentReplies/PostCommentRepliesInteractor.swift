//
//  PostCommentRepliesInteractor.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentRepliesBusinessLogic {
    func showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request)
    func showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request)
}

protocol PostCommentRepliesDataStore {
    var replies: [PostComment] { get set }
    var parentComment: PostComment { get set }
    var postID: Int { get set }
    var authorName: String? { get set }
    var image: UIImage { get set }
}

final class PostCommentRepliesInteractor: PostCommentRepliesBusinessLogic, PostCommentRepliesDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostCommentRepliesPresentationLogic?
    var worker: PostCommentRepliesWorker?
    
    // MARK: - Private Properties
    
    // MARK: - Data Store
    
    var replies: [PostComment] = []
    var parentComment: PostComment = PostComment(id: 00, parent: 00, authorName: "")
    var postID: Int = 0
    var authorName: String? = ""
    var image: UIImage = UIImage()
    
    // MARK: - Business Logic
    
    func showReplies(request: PostCommentRepliesModels.PostCommentReplies.Request) {
        if request.isReload {
            worker?.fetchReplies(id: parentComment.id, completion: { [weak self] (response, error) in
                guard let self = self else { return }
                self.replies = response ?? []
                self.presenter?.presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response())
            })
        } else {
            self.presenter?.presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response())
        }
    }
    
    func showSubmitReply(request: PostCommentRepliesModels.SubmitComment.Request) {
        worker?.createComment(content: request.content, post: postID, parent: parentComment.id, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.presenter?.presentSubmitCommentResult(response: PostCommentRepliesModels.SubmitComment.Response(error: error))
        })
    }
    
}
