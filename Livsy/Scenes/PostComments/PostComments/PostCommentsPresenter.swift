//
//  PostCommentsPresenter.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentsPresentationLogic {
    func presentPostComments(response: PostCommentsModels.PostComments.Response)
    func presentReplies(response: PostCommentsModels.Replies.Response)
    func presentSubmitCommentResult(response: PostCommentsModels.SubmitComment.Response)
}

final class PostCommentsPresenter: PostCommentsPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PostCommentsDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentPostComments(response: PostCommentsModels.PostComments.Response) {
        viewController?.displayPostComments(viewModel: PostCommentsModels.PostComments.ViewModel(isReload: response.isReload))
    }
    
    func presentReplies(response: PostCommentsModels.Replies.Response) {
        viewController?.diplsyReplies(viewModel: PostCommentsModels.Replies.ViewModel())
    }
    
    func presentSubmitCommentResult(response: PostCommentsModels.SubmitComment.Response) {
        viewController?.diplsySubmitCommentResult(viewModel: PostCommentsModels.SubmitComment.ViewModel(error: response.error))
    }
}
