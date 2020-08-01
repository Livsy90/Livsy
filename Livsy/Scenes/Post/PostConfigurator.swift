//
//  PostConfigurator.swift
//  Livsy
//
//  Created by Artem on 22.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class PostConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = PostConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: PostViewController) {
        let interactor = PostInteractor()
        let presenter = PostPresenter()
        let router = PostRouter()
        let worker = PostWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}

