//
//  PostCommentRepliesPresenter.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

protocol PostCommentRepliesPresentationLogic {
    func presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response)
    func presentSubmitCommentResult(response: PostCommentRepliesModels.SubmitComment.Response)
}

final class PostCommentRepliesPresenter: PostCommentRepliesPresentationLogic {
    
    // MARK: - Public Properties
    
    weak var viewController: PostCommentRepliesDisplayLogic?
    
    // MARK: - Private Properties
    
    // MARK: - Presentation Logic
    
    func presentReplies(response: PostCommentRepliesModels.PostCommentReplies.Response) {
        viewController?.displayReplies(request: PostCommentRepliesModels.PostCommentReplies.ViewModel())
    }
    
    func presentSubmitCommentResult(response: PostCommentRepliesModels.SubmitComment.Response) {
        viewController?.diplsySubmitCommentResult(viewModel: PostCommentRepliesModels.SubmitComment.ViewModel(error: response.error))
    }
}
