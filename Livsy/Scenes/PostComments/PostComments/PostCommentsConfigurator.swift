//
//  PostCommentsConfigurator.swift
//  Livsy
//
//  Created by Artem on 28.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostCommentsConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = PostCommentsConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: PostCommentsViewController) {
        let interactor = PostCommentsInteractor()
        let presenter = PostCommentsPresenter()
        let router = PostCommentsRouter()
        let worker = PostCommentsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
