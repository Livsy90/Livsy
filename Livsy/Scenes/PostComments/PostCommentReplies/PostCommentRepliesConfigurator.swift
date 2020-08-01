//
//  PostCommentRepliesConfigurator.swift
//  Livsy
//
//  Created by Artem on 30.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostCommentRepliesConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = PostCommentRepliesConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: PostCommentRepliesViewController) {
        let interactor = PostCommentRepliesInteractor()
        let presenter = PostCommentRepliesPresenter()
        let router = PostCommentRepliesRouter()
        let worker = PostCommentRepliesWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
