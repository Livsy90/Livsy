//
//  PostListConfigurator.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostListConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = PostListConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: PostListViewController) {
        let interactor = PostListInteractor()
        let presenter = PostListPresenter()
        let router = PostListRouter()
        let worker = PostListWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
