//
//  PostCommentsInteractor.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentsBusinessLogic {
    func showComments(request: PostCommentsModels.PostComments.Request)
    func showReplies(request: PostCommentsModels.Replies.Request)
    func submitComment(request: PostCommentsModels.SubmitComment.Request)
}

protocol PostCommentsDataStore {
    var commentsData: [PostComment] { get set }
    var commentAndReplies: [PostComment] { get set }
    var comments: [PostComment] { get set }
    var postID: Int { get set }
    var parentComment: PostComment { get set }
    var postTitle: String { get set }
    var authorName: String? { get set }
    var image: UIImage { get set }
}

final class PostCommentsInteractor: PostCommentsBusinessLogic, PostCommentsDataStore {
    
    // MARK: - Public Properties
    
    var presenter: PostCommentsPresentationLogic?
    var worker: PostCommentsWorker?
    
    // MARK: - Data Store
    
    var commentsData: [PostComment] = []
    var commentAndReplies: [PostComment] = []
    var comments: [PostComment] = []
    var postID: Int = 1
    var parentComment: PostComment = PostComment(id: 00, parent: 00, authorName: "", date: "")
    var postTitle: String = ""
    var authorName: String? = ""
    var image: UIImage = UIImage()
    
    // MARK: - Business Logic
    
    func showComments(request: PostCommentsModels.PostComments.Request) {
        let comments = commentsData
        if request.isReload {
            worker?.fetchPostComments(id: postID, completion: { [weak self] (response, error) in
                guard let self = self else { return }
                self.commentsData = response?.sorted(by: { $0.id < $1.id }) ?? []
                let isMultipleCommentsAppended = response?.count ?? 0 > comments.count + 1
                let isEditedByWeb = !(response?.contains(array: comments) ?? false)
                self.showSortedComments(isReload: request.isReload, isOneCommentAppend: !isMultipleCommentsAppended, isSubmitted: request.isSubmitted, isEditedByWeb: isEditedByWeb)
            })
            
        } else {
            showSortedComments(isReload: request.isReload, isOneCommentAppend: false, isSubmitted: false, isEditedByWeb: false)
        }
        
    }
    
    func showReplies(request: PostCommentsModels.Replies.Request) {
        commentAndReplies = request.replies?.sorted(by: { $0.id < $1.id }) ?? []
        parentComment = request.comment
        presenter?.presentReplies(response: PostCommentsModels.Replies.Response())
    }
    
    func submitComment(request: PostCommentsModels.SubmitComment.Request) {
        worker?.createComment(content: request.content, post: postID, parent: 0, completion: { [weak self] (response, error) in
            guard let self = self else { return }
            self.presenter?.presentSubmitCommentResult(response: PostCommentsModels.SubmitComment.Response(error: error))
        })
    }
    
    private func showSortedComments(isReload: Bool, isOneCommentAppend: Bool, isSubmitted: Bool, isEditedByWeb: Bool) {
        commentsData.forEach { comment  in
            guard comment.parent != 0,
                let parentCommentIndex = (commentsData.firstIndex { parentComment in
                    parentComment.id == comment.parent
                }) else { return }
            commentsData[parentCommentIndex].replies.append(comment)
        }
        
        comments = commentsData.filter { $0.parent == 0 }.sorted(by: { $0.id < $1.id })
        presenter?.presentPostComments(response: PostCommentsModels.PostComments.Response(isReload: isReload, isOneCommentAppended: isOneCommentAppend, isSubmited: isSubmitted, isEditedByWeb: isEditedByWeb))
    }
    
}
