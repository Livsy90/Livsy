//
//  TagsConfigurator.swift
//  Livsy
//
//  Created by Artem on 14.11.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import Foundation

final class TagsConfigurator {
    // MARK: Object lifecycle
    
    static let sharedInstance = TagsConfigurator()

    private init() {}
    
    // MARK: Configuration
    
    func configure(viewController: TagsViewController) {
        let interactor = TagsInteractor()
        let presenter = TagsPresenter()
        let router = TagsRouter()
        let worker = TagsWorker()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

}
